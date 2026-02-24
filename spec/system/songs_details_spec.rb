RSpec.describe "As a guest" do
  let(:song) { songs(:hotel_california) }

  before do
    visit song_path(song)
  end

  context "with no composer link" do
    before do
      song.composer.update! url: ""
    end

    scenario "if I do not add a #composer_link there is no link" do
      expect(page).to have_no_link(song.composer.name, href: "")
      expect(page).to have_content song.composer.name
    end
  end

  scenario "I can visit a song via its slug" do
    visit "/songs/#{song.slug}"
    expect(page).to have_content song.title
    visit songs_path
    click_on song.title
    expect(page).to have_current_path(song_path(song))
  end
end
