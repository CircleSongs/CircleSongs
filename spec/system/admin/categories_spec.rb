RSpec.describe "As an admin user" do
  let(:user) { users(:admin) }
  let(:restricted_category) { categories(:restricted) }
  let(:category) { categories(:traditional) }
  let(:name) { FFaker::Lorem.word }

  before do
    login_as user
  end

  scenario "I can create categories" do
    visit admin_categories_path

    click_on "New Category"
    fill_in "Name", with: name
    check "Restricted"
    click_on "Create Category"
    expect(page).to have_content "Category was successfully created."
    expect(page).to have_content "RESTRICTED YES"
  end

  scenario "I can view the index page" do
    visit admin_categories_path

    expect(page).to have_content "#{restricted_category.name} YES"
    expect(page).to have_content category.name
  end

  scenario "I can delete a category from the index page" do
    visit admin_categories_path
    within "#category_#{category.id}" do
      accept_confirm do
        click_on "Delete"
      end
    end
    expect(page).to have_content "Category was successfully destroyed."
  end

  scenario "I can delete a category from the show page" do
    visit admin_category_path(category)
    accept_confirm do
      click_on "Delete Category"
    end
    expect(page).to have_content "Category was successfully destroyed."
  end
end
