RSpec.describe "As an Admin user" do
  let(:user) { users(:admin) }
  let(:name) { "Sacred Songs" }
  let(:value) { FFaker::Internet.password }
  let(:new_value) { FFaker::Internet.password }

  before do
    login_as user
  end

  scenario "I can manage Passwords" do
    visit admin_passwords_path
    click_on "New Password"
    expect(page).to have_content("New Password")
    fill_in "Name", with: name
    fill_in "Value", with: value
    click_on "Create Password"
    expect(page).to have_content "Password was successfully created."
    expect(page).to have_content name
    expect(page).to have_content value
    within "table" do
      expect(page).to have_no_link "Delete"
      expect(page).to have_no_link "Show"
    end
    within(find("#index_table_passwords tbody tr", text: name)) do
      click_on "Edit"
    end
    expect(page).to have_field "Name", with: name, disabled: true
    expect(page).to have_field "Value", with: value
    fill_in "Value", with: new_value
    click_on "Update Password"
    expect(page).to have_content new_value
  end
end
