RSpec.feature 'As an Admin user' do
  let(:user) { users(:admin) }
  let(:name) { FFaker::Lorem.name }
  let(:value) { FFaker::Internet.password }
  let(:new_value) { FFaker::Internet.password }

  before do
    login_as user
  end

  scenario 'I can manage Passwords' do
    visit admin_passwords_path
    click_on 'New Password'
    fill_in 'Name', with: name
    fill_in 'Value', with: value
    click_on 'Create Password'
    expect(page).to have_content 'Password was successfully created.'
    expect(page).to have_content name
    expect(page).to have_content value
    expect(page).not_to have_content 'Delete'
    expect(page).not_to have_content 'Show'
    click_on 'Edit'
    expect(page).to have_field 'Name', with: name, disabled: true
    expect(page).to have_field 'Value', with: value
    fill_in 'Value', with: new_value
    click_on 'Update Password'
    expect(page).to have_content new_value
  end
end
