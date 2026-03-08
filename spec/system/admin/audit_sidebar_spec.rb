RSpec.describe "Admin Audit Sidebar" do
  let(:user) { users(:admin) }
  let(:composer) { composers(:the_eagles) }

  before do
    login_as user
  end

  scenario "show page displays the Audit sidebar" do
    composer.update!(created_by: user, updated_by: user)

    visit admin_composer_path(composer)

    expect(page).to have_text(/created by/i)
    expect(page).to have_text(/updated by/i)
    expect(page).to have_text(user.email)
    expect(page).to have_text(/created at/i)
    expect(page).to have_text(/updated at/i)
  end
end
