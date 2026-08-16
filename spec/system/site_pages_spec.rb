RSpec.describe "As a User" do
  let(:user) { users(:admin) }

  before do
    login_as user
    Flipper.enable_actor :v2_navigation, user
  end

  scenario "I see the new navigation" do
    visit root_path

    expect(page).to have_text(/Song Search/i)
    expect(page).to have_text(/About Us/i)
    expect(page).to have_text(/Resources/i)
    expect(page).to have_text(/Songbook/i)
    expect(page).to have_text(/Support Us/i)
    expect(page).to have_no_text(/Ikaros/i)
  end
end
