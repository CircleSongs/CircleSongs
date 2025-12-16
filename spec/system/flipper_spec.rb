RSpec.feature "As a visitor", type: :system do
  let(:user) { users(:admin) }

  scenario "Flipper is working" do
    visit root_path

    find("i.fa-right-to-bracket").click

    fill_in "Email", with: user.email
    fill_in "Password", with: PasswordHelper.default_password
    click_on "Login"
    visit root_path

    expect(page).to have_link(href: admin_dashboard_path)

    Flipper.enable_actor :hide_admin_login, user
    visit root_path
    expect(page).to have_no_link(href: admin_dashboard_path)
  end
end
