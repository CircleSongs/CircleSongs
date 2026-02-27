RSpec.describe "Admin Composers", type: :system do
  let(:user) { users(:admin) }
  let(:composer) { composers(:the_eagles) }

  before do
    login_as user
  end

  scenario "I can view the composers index page" do
    visit admin_composers_path

    expect(page).to have_content composer.name
  end

  scenario "name links to show page" do
    visit admin_composers_path

    within "#composer_#{composer.id}" do
      click_link composer.name
    end

    expect(page).to have_current_path(admin_composer_path(composer))
  end

  scenario "songs count links to songs filtered by composer" do
    visit admin_composers_path

    within "#composer_#{composer.id}" do
      click_link composer.songs_count.to_s
    end

    expect(page).to have_current_path(admin_songs_path(q: { composer_name_cont: composer.name }))
  end

  scenario "I can view a composer show page" do
    visit admin_composer_path(composer)

    expect(page).to have_content composer.name
  end
end
