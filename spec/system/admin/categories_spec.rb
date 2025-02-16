RSpec.feature "As an admin user" do
  let(:user) { users(:admin) }
  let(:restricted_category) { categories(:restricted) }
  let(:category) { categories(:traditional) }
  let(:name) { FFaker::Lorem.word }

  before do
    login_as user
    visit admin_categories_path
  end

  scenario "I can create categories" do
    click_on "New Category"
    fill_in "Name", with: name
    check "Restricted"
    click_on "Create Category"
    expect(page).to have_content "Category was successfully created."
    expect(page).to have_content "Restricted Yes"
  end

  scenario "I can view the index page" do
    expect(page).to have_content "#{restricted_category.name} Yes"
    expect(page).to have_content category.name
  end
end
