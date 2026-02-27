RSpec.describe "Admin Recordings", type: :system do
  let(:user) { users(:admin) }
  let(:recording) { recordings(:hotel_california_soundclound) }
  let(:song) { songs(:hotel_california) }

  before do
    login_as user
  end

  scenario "I can view the recordings index page" do
    visit admin_recordings_path

    expect(page).to have_content recording.title
    expect(page).to have_link song.title, href: admin_song_path(song)
  end

  scenario "I can view a recording show page" do
    visit admin_recording_path(recording)

    expect(page).to have_content recording.title
    expect(page).to have_link song.title, href: admin_song_path(song)
    expect(page).to have_content recording.description if recording.description.present?
  end
end
