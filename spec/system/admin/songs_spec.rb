RSpec.describe "As an admin user" do
  let(:user) { users(:admin) }
  let(:title) { FFaker::Music.song }
  let(:chord_form) { chord_forms(:Am7) }
  let(:song) { songs(:hotel_california) }
  let(:embed_code) { "https://www.youtube.com/watch?v=123456789" }

  before do
    login_as user
  end

  scenario "I can add a song", :js do
    visit admin_songs_path
    click_on "New Song"
    fill_in "Title", with: title
    attach_file "Image", Rails.root.join("spec/fixtures/files/image.jpeg")
    click_on "Add new chord form"
    select chord_form.chord

    click_on "Add New Recording"
    fill_in "Embedded player*", with: embed_code

    click_on "Create Song"
    expect(page).to have_content "Song was successfully created."
    expect(find("img")["src"]).to eq Song.find_by(title: title).image_url(:thumb)
    expect(page).to have_content chord_form.chord
    expect(page).to have_css "div.chord-form svg"
  end

  scenario "I see an edit link on the public index page" do
    visit songs_path
    expect(page).to have_css "a.edit"
    expect(page).to have_css ".has-recording"
  end

  scenario "I can delete a song from the index page" do
    visit admin_songs_path
    within "#song_#{song.id}" do
      accept_confirm do
        click_on "Delete"
      end
    end
    expect(page).to have_content "Song was successfully destroyed."
  end

  scenario "I can delete a song from the show page" do
    visit admin_song_path(song)
    accept_confirm do
      click_on "Delete Song"
    end
    expect(page).to have_content "Song was successfully destroyed."
  end
end
