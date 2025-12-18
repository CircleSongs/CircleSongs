RSpec.feature "As an admin user", type: :system do
  let(:user) { users(:admin) }
  let(:title) { FFaker::Music.song }
  let(:youtube_link) { "https://www.youtube.com/watch?v=yCjJyiqpAuU" }

  before do
    login_as user
  end

  scenario "I can create Recordings while creating a Song", :js do
    visit admin_songs_path
    click_on "New Song"

    attach_file "Image", Rails.root.join("spec/fixtures/files/image.jpeg")
    fill_in "Title", with: title
    click_on "Add New Recording"
    click_on "Create Song"
    expect(page).not_to have_selector("table.recordings tbody")
    click_on "Edit Song"
    click_on "Add New Recording"
    fill_in "Url", with: youtube_link
    click_on "Update Song"
    within "table.recordings tbody" do
      expect(page).to have_link(youtube_link, href: youtube_link)
    end
    click_on "Edit Song"
    within "li.recordings" do
      check "Delete"
    end
    click_on "Update Song"
    expect(page).not_to have_selector("table.recordings tbody")
  end
end
