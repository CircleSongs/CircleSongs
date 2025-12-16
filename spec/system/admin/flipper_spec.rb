RSpec.feature "As an authenticated User", type: :system do
  before do
    login_as user
  end
  context "with admin privileges" do
    let(:user) { users(:admin) }

    scenario "I can manage Flipper features" do
      visit admin_dashboard_path

      click_on "Flipper"
      expect(page).to have_content("Flipper")
    end
  end

  context "without admin privileges" do
    let(:user) { users(:homer) }

    scenario "I cannot manage Flipper features" do
      visit admin_dashboard_path

      expect(page).to have_no_content "Flipper"

      visit "/admin/flipper"

      expect(page).to have_content("Routing Error")
    end
  end
end
