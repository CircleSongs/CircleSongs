RSpec.describe "As a guest" do
  let(:hotel_california) { songs(:hotel_california) }
  let(:taki_taki) { songs(:taki_taki) }
  let(:el_condor_pasa) { songs(:el_condor_pasa) }
  let(:chords) { "[Dm]On a dark desert [A]highway, [Em]cool wind in my hair..." }
  let(:formatted_chords) { "On a dark desert highway" }

  before do
    hotel_california.update!(theme_list: ["classic rock"])
    taki_taki.update!(theme_list: ["traditional"])
    el_condor_pasa.update!(theme_list: ["traditional"])

    visit songs_path
  end

  scenario "I can view songs" do
    click_on hotel_california.title

    expect(page).to have_content hotel_california.title
    expect(page).to have_content hotel_california.alternate_title
    expect(page).to have_content hotel_california.composer.name
    expect(page).to have_content "On a dark desert highway, cool wind in my hair"
    expect(page).to have_content hotel_california.translation
    expect(page).to have_content hotel_california.categories.map(&:name).to_sentence
    expect(page).to have_no_content chords
    expect(page).to have_content formatted_chords
  end

  scenario "I can search across title, lyrics, and composer with consolidated search" do
    visit songs_path
    fill_in I18n.t("songs.search_placeholder"), with: "Foo"
    click_on "Search Songs"
    expect(page).to have_content I18n.t("songs.no_songs")

    fill_in I18n.t("songs.search_placeholder"), with: "California"
    click_on "Search Songs"
    expect(page).to have_content hotel_california.title
    expect(page).to have_no_content taki_taki.title
    expect(page).to have_no_content el_condor_pasa.title

    click_on "Reset Form"

    fill_in I18n.t("songs.search_placeholder"), with: "desert highway"
    click_on "Search Songs"
    expect(page).to have_content hotel_california.title
    expect(page).to have_no_content taki_taki.title
    expect(page).to have_no_content el_condor_pasa.title

    click_on "Reset Form"

    fill_in I18n.t("songs.search_placeholder"), with: "Eagles"
    click_on "Search Songs"
    expect(page).to have_content hotel_california.title
    expect(page).to have_no_content taki_taki.title
    expect(page).to have_no_content el_condor_pasa.title
  end

  scenario "I can search for songs by theme" do
    visit songs_path
    select "traditional", from: "theme"
    click_on "Search Songs"

    expect(page).to have_content taki_taki.title
    expect(page).to have_content el_condor_pasa.title
    expect(page).to have_no_content hotel_california.title
  end

  scenario "I can sort songs by language" do
    click_on "Language"

    rows = all("tbody tr td:last-child").map(&:text)
    expect(rows).to eq rows.sort

    click_on "Language"

    rows = all("tbody tr td:last-child").map(&:text)
    expect(rows).to eq rows.sort.reverse
  end

  scenario "I can change the number of songs per page" do
    select "10", from: "per_page"
    expect(page).to have_select("per_page", selected: "10")
  end

  scenario "per-page limits the number of songs displayed" do
    visit songs_path(per_page: 2)
    expect(page).to have_css("tr.songrow", count: 2)
    expect(page).to have_content("Showing 2 of 3 results")
  end

  scenario "per-page setting persists when searching" do
    select "25", from: "per_page"
    fill_in I18n.t("songs.search_placeholder"), with: "California"
    click_on "Search Songs"
    expect(page).to have_select("per_page", selected: "25")
  end

  scenario "I do not see an edit link" do
    expect(page).to have_no_css "a.edit"
    expect(page).to have_no_css ".has_recording"
  end
end
