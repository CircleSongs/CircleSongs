RSpec.feature "As a guest", type: :system do
  let(:hotel_california) { songs(:hotel_california) }
  let(:taki_taki) { songs(:taki_taki) }
  let(:el_condor_pasa) { songs(:el_condor_pasa) }
  let(:chords) { "[Dm]On a dark desert [A]highway, [Em]cool wind in my hair..." }
  let(:formatted_chords) { "On a dark desert highway" }

  before do
    visit songs_path
  end

  scenario "I can view songs", :selenium do
    click_on hotel_california.title
    expect(page).to have_content hotel_california.title
    expect(page).to have_content hotel_california.alternate_title
    expect(page).to have_content hotel_california.composer.name
    expect(page).to have_content hotel_california.lyrics
    expect(page).to have_content hotel_california.translation
    expect(page).to have_content hotel_california.categories.map(&:name).to_sentence
    expect(page).to have_no_content chords
    expect(page).to have_content formatted_chords
  end

  scenario "I can search for songs" do
    fill_in "Search titles...", with: "Foo"
    click_on "Search"
    expect(page).to have_content I18n.t("songs.no_songs")

    fill_in "Search titles...", with: "California"
    click_on "Search"
    expect(page).to have_content hotel_california.title
    expect(page).to have_no_content taki_taki.title
    expect(page).to have_no_content el_condor_pasa.title

    click_on "Clear"

    select "Traditional"
    click_on "Search"
    expect(page).to have_content el_condor_pasa.title
    expect(page).to have_no_content taki_taki.title
    expect(page).to have_no_content hotel_california.title

    click_on "Clear"

    select "Spanish"
    click_on "Search"
    expect(page).to have_no_content hotel_california.title
    expect(page).to have_no_content taki_taki.title
    expect(page).to have_content el_condor_pasa.title
  end

  scenario "I do not see an edit link" do
    expect(page).to have_no_css "a.edit"
    expect(page).to have_no_css ".has_recording"
  end
end
