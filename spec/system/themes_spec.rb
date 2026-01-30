RSpec.feature "As a guest", type: :system do
  scenario "I can see category counts beside the category name" do
    visit songs_path

    within ".themes" do
      click_on "traditional"
    end

    expect(page).to have_content "Traditional"
  end
end
