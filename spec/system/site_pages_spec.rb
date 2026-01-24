RSpec.describe "As a User", type: :system do
  scenario "I see the legacy navigation" do
    visit root_path
    expect(page).to have_no_content("About Us")
    expect(page).to have_no_content("Resources")
    expect(page).to have_no_content("Support Us")
    expect(page).to have_no_content("Song Book")
    expect(page).to have_content("Icaros")
    expect(page).to have_content("Quechua")
  end

  context "with :v2_navigation enabled" do
    let(:user) { users(:admin) }

    before do
      login_as user
      Flipper.enable_actor :v2_navigation, user
    end

    scenario "I see the new navigation" do
      visit root_path
      expect(page).to have_content("About Us")
      expect(page).to have_content("Resources")
      expect(page).to have_content("Support Us")
      expect(page).to have_content("Song Book")

      expect(page).to have_no_content("Icaros")
    end
  end
end
