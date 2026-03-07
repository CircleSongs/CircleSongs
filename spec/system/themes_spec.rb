RSpec.describe "As a guest" do
  let(:el_condor_pasa) { songs(:el_condor_pasa) }
  let(:taki_taki) { songs(:taki_taki) }
  let(:non_traditional_song) { songs(:hotel_california) }
  before do
    [el_condor_pasa, taki_taki].each do |song|
      song.theme_list.add("traditional")
      song.save!
    end
  end

  scenario "I can filter songs by theme" do
    visit songs_path

    # No label, target by id
    select "traditional", from: "theme"
    click_on "Search Songs"

    expect(page).to have_content el_condor_pasa.title
    expect(page).to have_content taki_taki.title
    expect(page).to have_no_content non_traditional_song.title
  end
end
