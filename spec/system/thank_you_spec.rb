RSpec.feature "As a user", type: :system do
  scenario "having left a donation I see a thank you message" do
    visit "/donation_thank_you"
    expect(page).to have_content I18n.t("thank_you.donation")
  end

  scenario "having made a purchase I see a thank you message" do
    visit "/purchase_thank_you"
    expect(page).to have_content I18n.t("thank_you.purchase")
  end
end
