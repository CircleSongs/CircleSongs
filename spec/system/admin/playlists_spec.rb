RSpec.describe "Admin Playlists", type: :system do
  let(:user) { users(:admin) }
  let(:spotify) { playlists(:spotify) }
  let(:youtube) { playlists(:youtube) }

  before do
    login_as user
  end

  scenario "I can view the playlists index page" do
    visit admin_playlists_path

    expect(page).to have_content spotify.title
    expect(page).to have_content youtube.title
  end

  scenario "I can view a playlist show page" do
    visit admin_playlist_path(spotify)

    expect(page).to have_content spotify.title
    expect(page).to have_content spotify.description
    expect(page).to have_link spotify.url, href: spotify.url
  end

  scenario "I can create a new playlist" do
    visit admin_playlists_path

    click_on "New Playlist"
    fill_in "Title", with: "New Playlist"
    fill_in "Description", with: "A great new playlist"
    fill_in "Url", with: "https://open.spotify.com/playlist/123456"
    click_on "Create Playlist"

    expect(page).to have_content "Playlist was successfully created."
    expect(page).to have_content "New Playlist"
  end

  scenario "I can edit a playlist" do
    visit admin_playlist_path(spotify)

    click_on "Edit Playlist"
    fill_in "Title", with: "Updated Title"
    click_on "Update Playlist"

    expect(page).to have_content "Playlist was successfully updated."
    expect(page).to have_content "Updated Title"
  end

  scenario "I can delete a playlist from the show page" do
    visit admin_playlist_path(spotify)

    accept_confirm do
      click_on "Delete Playlist"
    end

    expect(page).to have_content "Playlist was successfully destroyed."
  end
end
