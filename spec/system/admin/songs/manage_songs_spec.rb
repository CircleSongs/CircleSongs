RSpec.describe "As an admin user" do
  let(:user) { users(:admin) }
  let(:title) { FFaker::Music.song }
  let(:chord_form) { chord_forms(:Am7) }
  let(:song) { songs(:hotel_california) }
  let(:embed_code) { "https://www.youtube.com/watch?v=123456789" }

  before do
    login_as user
  end

  scenario "I see an edit link on the public index page" do
    visit songs_path
    expect(page).to have_css "a.edit"
    expect(page).to have_css ".has-recording"
  end

  scenario "I can delete a song from the index page" do
    visit admin_songs_path
    within "#song_#{song.id}" do
      accept_confirm do
        click_on "Delete"
      end
    end
    expect(page).to have_content "Song was successfully destroyed."
  end

  scenario "I can delete a song from the show page" do
    visit admin_song_path(song)
    accept_confirm do
      click_on "Delete"
    end
    expect(page).to have_content "Song was successfully destroyed."
  end

  scenario "I can edit a Song that has no image" do
    visit admin_song_path(song)
    click_on "Edit"
    within "#song_title_input" do
      fill_in "Title", with: "New Title"
    end
    click_on "Update Song"
    expect(page).to have_content "Song was successfully updated."
    expect(song.reload.title).to eq "New Title"
  end

  scenario "I can mark a song as featured", :focus do
    visit edit_admin_song_path(song)
    check "Featured"
    click_on "Update Song"
    expect(page).to have_content "Song was successfully updated."
    expect(song.reload.featured).to be true
    visit admin_songs_path
    select "Yes", from: "Featured"
    click_on "Filter"
    expect(page).to have_content song.title
    select "No", from: "Featured"
    click_on "Filter"
    expect(page).to have_no_content song.title
  end
end
