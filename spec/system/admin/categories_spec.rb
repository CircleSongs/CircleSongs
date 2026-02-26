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
    fill_in "Description", with: "A test description"
    check "Restricted"
    click_on "Create Category"
    expect(page).to have_content "Category was successfully created."
    expect(page).to have_content "RESTRICTED YES"
    expect(page).to have_content "A test description"
  end

  scenario "I can view the index page" do
    visit admin_categories_path

    expect(page).to have_content "#{restricted_category.name} YES"
    expect(page).to have_content category.name
  end

  scenario "I can see drag handles on the index page" do
    visit admin_categories_path

    expect(page).to have_css "td.handle", minimum: 1
    expect(page).to have_content "☰"
  end

  scenario "I can reorder categories via drag and drop", :js do
    popular = categories(:popular)
    traditional = categories(:traditional)
    sacred = categories(:sacred)
    restricted = categories(:restricted)

    visit admin_categories_path

    # Verify initial order (position_asc)
    ids_from_rows = page.all("table.index_table tbody tr").map { |r| r[:id].sub(/^[^_]+_/, "") }
    expect(ids_from_rows).to eq [popular, traditional, sacred, restricted].map(&:id)

    # Simulate the sort POST that the drag-and-drop JS fires
    new_order = [sacred, traditional, popular, restricted].map(&:id)
    page.execute_script <<~JS
      $.post(window.location.pathname + "/sort", { ids: #{new_order.to_json} });
    JS
    sleep 0.5

    # Reload and verify new order persisted
    visit admin_categories_path
    reordered_ids = page.all("table.index_table tbody tr").map { |r| r[:id].sub(/^[^_]+_/, "") }
    expect(reordered_ids).to eq new_order
  end

  scenario "I can edit a category description" do
    visit edit_admin_category_path(category)

    fill_in "Description", with: "Updated description"
    click_on "Update Category"
    expect(page).to have_content "Category was successfully updated."
    expect(category.reload.description).to eq "Updated description"
  end

  scenario "I can see description on the index page" do
    visit admin_categories_path

    expect(page).to have_content category.description
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
