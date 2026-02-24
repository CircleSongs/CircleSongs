RSpec.describe "As a User", type: :system do
    let(:user) { users(:admin) }

    before do
      login_as user
      Flipper.enable_actor :v2_navigation, user
    end

    scenario "I see the new navigation" do
      visit root_path

      expect(page).to have_content(/Song Search/i)
      expect(page).to have_content(/About Us/i)
      expect(page).to have_content(/Resources/i)
      expect(page).to have_content(/Songbook/i)
      expect(page).to have_content(/Support Us/i)
      expect(page).to have_no_content(/Icaros/i)
    end
  end
