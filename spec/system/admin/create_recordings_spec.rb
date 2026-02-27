RSpec.describe "As an admin user" do
  let(:user) { users(:admin) }
  let(:title) { FFaker::Music.song }
  let(:youtube_link) { "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
  let(:soundcloud_link) { "https://soundcloud.com/dinshaw/fire-and-rain-4-15-21" }

  before do
    login_as user
  end

  scenario "I can create Recordings with SoundCloud URL", :js do
    visit admin_songs_path
    click_on "New Song"

    attach_file "Image", Rails.root.join("spec/fixtures/files/image.jpeg")
    fill_in "Title", with: title
    click_on "Add New Recording"
    fill_in "External media url", with: soundcloud_link
    click_on "Create Song"

    expect(page).to have_content("Song was successfully created")

    song = Song.find_by(title: title)
    expect(song.recordings.count).to eq(1)
    expect(song.recordings.first.external_media_url).to eq(soundcloud_link)
  end

  scenario "I can create Recordings with YouTube URL", :js do
    visit admin_songs_path
    click_on "New Song"

    attach_file "Image", Rails.root.join("spec/fixtures/files/image.jpeg")
    fill_in "Title", with: title
    click_on "Add New Recording"
    fill_in "External media url", with: youtube_link
    click_on "Create Song"

    expect(page).to have_content("Song was successfully created")

    song = Song.find_by(title: title)
    expect(song.recordings.count).to eq(1)
    expect(song.recordings.first.external_media_url).to eq(youtube_link)
  end

  scenario "I can create and delete Recordings", :js do
    visit admin_songs_path
    click_on "New Song"

    attach_file "Image", Rails.root.join("spec/fixtures/files/image.jpeg")
    fill_in "Title", with: title
    click_on "Add New Recording"
    click_on "Create Song"
    expect(page).to have_content("Song was successfully created")

    song = Song.find_by(title: title)
    visit edit_admin_song_path(song)

    click_on "Add New Recording"
    fill_in "External media url", with: soundcloud_link
    click_on "Update Song"

    expect(page).to have_content("Song was successfully updated")
    expect(song.recordings.count).to eq(1)

    visit edit_admin_song_path(song)

    within ".has-many-container fieldset.has-many-fields:first-of-type" do
      check "Delete"
    end
    click_on "Update Song"
    expect(page).not_to have_selector("table.recordings tbody")
  end

end
