RSpec.describe "Admin Tags", type: :system do
  let(:user) { users(:admin) }
  let(:song) { songs(:hotel_california) }

  before do
    song.update!(theme_list: ["classic rock"])
    login_as user
  end

  scenario "I can view the tags index page" do
    visit admin_tags_path

    expect(page).to have_content "classic rock"
  end

  scenario "name links to show page" do
    tag = ActsAsTaggableOn::Tag.find_by!(name: "classic rock")

    visit admin_tags_path
    click_link "classic rock"

    expect(page).to have_current_path(admin_tag_path(tag))
  end

  scenario "usage count links to songs filtered by theme" do
    tag = ActsAsTaggableOn::Tag.find_by!(name: "classic rock")

    visit admin_tags_path

    click_link tag.taggings_count.to_s

    expect(page).to have_current_path(admin_songs_path(q: { themes_name_in: ["classic rock"] }))
    expect(page).to have_content song.title
  end

  scenario "I can view a tag show page" do
    visit admin_tag_path(ActsAsTaggableOn::Tag.find_by!(name: "classic rock"))

    expect(page).to have_content "classic rock"
    expect(page).to have_content song.title
  end
end
