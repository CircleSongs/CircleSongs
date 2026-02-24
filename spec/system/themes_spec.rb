RSpec.describe "As a guest" do
  scenario "I can filter songs by theme" do
    visit songs_path

    select "traditional", from: "theme"
    click_on "Search Songs"

    expect(page).to have_content "Traditional"
  end
end
