RSpec.describe "As an admin user" do
  let(:user) { users(:admin) }
  let(:email) { FFaker::Internet.email }
  let(:new_email) { FFaker::Internet.email }
  let(:password) { FFaker::Internet.password }

  before do
    login_as user
  end

  scenario "I can create a user", :js do
    visit admin_users_path
    click_on "New User"
    fill_in "Email", with: email
    fill_in "Password", with: password, match: :prefer_exact
    fill_in "Password confirmation", with: password, match: :prefer_exact
    click_on "Create User"
    expect(page).to have_content "User was successfully created."
    expect(page).to have_content email
    within "tbody tr:nth-child(1)" do
      click_on "Edit"
    end
    fill_in "Email", with: new_email
    fill_in "Password", with: password, match: :prefer_exact
    fill_in "Password confirmation", with: password, match: :prefer_exact
    click_on "Update User"
    expect(page).to have_content "User was successfully updated."
    expect(page).to have_content new_email
  end

  scenario "I can change a user's password" do
    homer = users(:homer)
    new_password = FFaker::Internet.password
    visit edit_admin_user_path(homer)
    fill_in "Password", with: new_password, match: :prefer_exact
    fill_in "Password confirmation", with: new_password, match: :prefer_exact
    click_on "Update User"
    expect(page).to have_content "User was successfully updated."
    expect(homer.reload.valid_password?(new_password)).to be true
  end

  scenario "I can disable a user without changing their password" do
    homer = users(:homer)
    visit edit_admin_user_path(homer)
    check "Disabled"
    click_on "Update User"
    expect(page).to have_content "User was successfully updated."
    expect(homer.reload).to be_disabled
  end

  scenario "I cannot delete a user" do
    visit admin_users_path
    expect(page).to have_no_link "Delete"
  end
end
