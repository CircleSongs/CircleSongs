RSpec.feature 'As an admin user' do
  let(:user) { users(:admin) }
  let(:email) { FFaker::Internet.email }
  let(:new_email) { FFaker::Internet.email }
  let(:password) { FFaker::Internet.password }

  before do
    login_as user
  end

  scenario 'I can create a user', :chrome do
    visit admin_users_path
    click_on 'New User'
    fill_in 'Email', with: email
    fill_in 'Password', with: password, match: :prefer_exact
    fill_in 'Password confirmation', with: password, match: :prefer_exact
    click_on 'Create User'
    expect(page).to have_content 'User was successfully created.'
    expect(page).to have_content email
    within 'tbody tr:nth-child(1)' do
      click_on 'Edit'
    end
    fill_in 'Email', with: new_email
    fill_in 'Password', with: password, match: :prefer_exact
    fill_in 'Password confirmation', with: password, match: :prefer_exact
    click_on 'Update User'
    expect(page).to have_content 'User was successfully updated.'
    expect(page).to have_content new_email
  end
end
