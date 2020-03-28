def authorize_restricted_categories
  visit root_path
  click_on 'traditions of healing'
  fill_in(
    I18n.t('restricted_categories.password_label'),
    with: Rails.application.credentials.restricted_category_password
  )
  click_on 'Submit'
end
