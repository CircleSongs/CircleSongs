RSpec.describe "As an admin user" do
  let(:user) { users(:admin) }
  let(:song) { songs(:hotel_california) }

  before do
    login_as user
  end

  scenario "I can add new tags to a song" do
    # Ensure song has no existing tags
    song.update!(theme_list: [])

    visit edit_admin_song_path(song)

    # Add first new tag by typing and pressing Enter
    within('#song_theme_list_input') do
      find("input#song_theme_list-ts-control").set "foo, bar"
    end

    click_on "Update Song"

    expect(page).to have_content "foo"
  end
end
