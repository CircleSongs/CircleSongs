def login
  user = users(:admin)
  visit '/admin/login'
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: PasswordHelper.default_password
  click_button 'Login'
end
