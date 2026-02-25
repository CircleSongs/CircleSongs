require "rails_helper"

RSpec.describe "Home page", type: :system do
  let(:song) { songs(:hotel_california) }

  scenario "featured song displays lyrics as plain text with tags stripped" do
    visit root_path

    within ".featured__excerpt" do
      expect(page).to have_text("cool wind")
      expect(page).not_to have_css("em")
    end
  end

  scenario "featured song truncates long lyrics" do
    song.update!(lyrics: "a\n" * 200)
    visit root_path

    within ".featured__excerpt" do
      expect(page).to have_text("...")
    end
  end
end
