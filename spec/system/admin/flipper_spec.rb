RSpec.describe "As an authenticated User" do
  before do
    login_as user
  end
  context "with admin privileges" do
    let(:user) { users(:admin) }

    scenario "I can manage Flipper features" do
      visit admin_dashboard_path
      expect(page).to have_text("System")

      click_on "System"
      click_on "Flipper"
      expect(page).to have_text("Flipper")
    end
  end

  context "without admin privileges" do
    let(:user) { users(:homer) }

    scenario "I cannot manage Flipper features" do
      visit admin_dashboard_path
      expect(page).to have_text("Dashboard")

      expect(page).to have_no_text "Flipper"

      visit "/admin/flipper"

      expect(page).to have_text("Routing Error")
    end
  end
end
