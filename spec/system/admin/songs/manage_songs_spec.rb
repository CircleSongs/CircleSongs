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
  end

  scenario "song title on index links to show page" do
    visit admin_songs_path

    within "#song_#{song.id}" do
      click_link song.title
    end

    expect(page).to have_current_path(admin_song_path(song))
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

  scenario "I can see drag handles for recordings on the show page" do
    visit admin_song_path(song)

    within ".panel" do
      expect(page).to have_css "td.handle", minimum: 1
      expect(page).to have_content "☰"
    end
  end

  scenario "show page renders recordings in position order" do
    r1 = recordings(:hotel_california_soundclound)
    r2 = recordings(:hotel_california_the_eagles)
    r3 = recordings(:hotel_california_spotify)
    r4 = recordings(:hotel_california_bandcamp)

    # Set positions in reverse of creation order
    r4.update_column(:position, 1)
    r3.update_column(:position, 2)
    r2.update_column(:position, 3)
    r1.update_column(:position, 4)

    visit admin_song_path(song)

    titles = page.all("table.sortable-show tbody tr td:nth-child(2)").map(&:text)
    expect(titles).to eq [r4.title, r3.title, r2.title, r1.title]
  end

  scenario "I can reorder recordings via drag and drop on the show page", :js do
    r1 = recordings(:hotel_california_soundclound)
    r2 = recordings(:hotel_california_the_eagles)
    r3 = recordings(:hotel_california_spotify)
    r4 = recordings(:hotel_california_bandcamp)

    [r1, r2, r3, r4].each_with_index { |r, i| r.update_column(:position, i + 1) }

    visit admin_song_path(song)

    ids_from_rows = page.all("table.sortable-show tbody tr").map { |r| r[:id].sub(/^[^_]+_/, "") }
    expect(ids_from_rows).to eq [r1, r2, r3, r4].map(&:id)

    # Simulate the sort POST that the drag-and-drop JS fires
    new_order = [r3, r1, r4, r2].map(&:id)
    ids_param = new_order.map { |id| "ids[]=#{id}" }.join("&")
    sort_url = sort_recordings_admin_song_path(song)
    page.execute_script <<~JS
      var csrfMeta = document.querySelector('meta[name="csrf-token"]');
      var headers = { "Content-Type": "application/x-www-form-urlencoded" };
      if (csrfMeta) { headers["X-CSRF-Token"] = csrfMeta.content; }
      fetch("#{sort_url}", {
        method: "POST",
        headers: headers,
        body: "#{ids_param}"
      });
    JS
    sleep 0.5

    visit admin_song_path(song)
    reordered_ids = page.all("table.sortable-show tbody tr").map { |r| r[:id].sub(/^[^_]+_/, "") }
    expect(reordered_ids).to eq new_order
  end

  scenario "I can mark a song as featured" do
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
