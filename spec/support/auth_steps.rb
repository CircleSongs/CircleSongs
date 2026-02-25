def authorize_restricted_categories(password)
  visit root_path
  click_on "traditions of healing"
  fill_in(
    I18n.t("restricted_categories.password_label"),
    with: password
  )
  click_on "Submit"
  expect(page).to have_content "Welcome to the chamber of secrets!"
end
