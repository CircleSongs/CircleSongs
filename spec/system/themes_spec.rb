RSpec.describe "As a guest" do
  let(:traditional_song_1) { songs(:el_condor_pasa) }
  let(:traditional_song_2) { songs(:taki_taki) }
  let(:non_traditional_song) { songs(:hotel_california) }
  before do
    [traditional_song_1, traditional_song_2].each do |song|
      song.theme_list.add("traditional")
      song.save!
    end
  end

  scenario "I can filter songs by theme" do
    visit songs_path

    # No label, target by id
    select "traditional", from: "theme"
    click_on "Search Songs"

    expect(page).to have_content traditional_song_1.title
    expect(page).to have_content traditional_song_2.title
    expect(page).to have_no_content non_traditional_song.title
  end
end
