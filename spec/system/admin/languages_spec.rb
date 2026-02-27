RSpec.describe "Admin Languages", type: :system do
  let(:user) { users(:admin) }
  let(:language) { languages(:english) }

  before do
    login_as user
  end

  scenario "I can view the languages index page" do
    visit admin_languages_path

    expect(page).to have_content language.name
  end

  scenario "songs count links to songs filtered by language" do
    visit admin_languages_path

    within "#language_#{language.id}" do
      click_link language.songs.size.to_s
    end

    expect(page).to have_current_path(admin_songs_path(q: { languages_id_in: [language.id] }))
  end
end
