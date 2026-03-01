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

  scenario "title links to show page" do
    visit admin_playlists_path

    within "#playlist_#{spotify.id}" do
      click_link spotify.title
    end

    expect(page).to have_current_path(admin_playlist_path(spotify))
  end

  scenario "I can see drag handles on the index page" do
    visit admin_playlists_path

    expect(page).to have_css "td.handle", minimum: 1
    expect(page).to have_content "☰"
  end

  scenario "I can reorder playlists via drag and drop", :js do
    soundcloud = playlists(:soundcloud)
    bandcamp = playlists(:bandcamp)

    visit admin_playlists_path

    # Verify initial order (position_asc)
    ids_from_rows = page.all("table.data-table tbody tr").map { |r| r[:id].sub(/^[^_]+_/, "") }
    expect(ids_from_rows).to eq [spotify, youtube, soundcloud, bandcamp].map(&:id)

    # Simulate the sort POST that the drag-and-drop JS fires
    new_order = [bandcamp, soundcloud, youtube, spotify].map(&:id)
    ids_param = new_order.map { |id| "ids[]=#{id}" }.join("&")
    page.execute_script <<~JS
      var csrfMeta = document.querySelector('meta[name="csrf-token"]');
      var headers = { "Content-Type": "application/x-www-form-urlencoded" };
      if (csrfMeta) { headers["X-CSRF-Token"] = csrfMeta.content; }
      fetch(window.location.pathname + "/sort", {
        method: "POST",
        headers: headers,
        body: "#{ids_param}"
      });
    JS
    sleep 0.5

    # Reload and verify new order persisted
    visit admin_playlists_path
    reordered_ids = page.all("table.data-table tbody tr").map { |r| r[:id].sub(/^[^_]+_/, "") }
    expect(reordered_ids).to eq new_order
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
