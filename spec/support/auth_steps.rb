def login
  user = users(:admin)
  visit '/admin/login'
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: PasswordHelper.default_password
  click_button 'Login'
end

def authorize_restricted_categories
  visit root_path
  click_on 'traditions of healing'
  fill_in I18n.t('restricted_categories.password_label'), with: ENV['restricted_category_password']
  click_on 'Submit'
end
