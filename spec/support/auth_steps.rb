def login
  user = users(:admin)
  visit '/admin/login'
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: PasswordHelper.default_password
  click_button 'Login'
end

def authorize_restricted_categories
  visit root_path
  click_on 'special'
  fill_in 'Username...', with: 'username'
  fill_in 'Password...', with: 'password'
  click_on 'Submit'
end
