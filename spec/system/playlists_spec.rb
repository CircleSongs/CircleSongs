RSpec.describe "Playlists" do
  let(:spotify) { playlists(:spotify) }
  let(:youtube) { playlists(:youtube) }
  let(:soundcloud) { playlists(:soundcloud) }
  let(:bandcamp) { playlists(:bandcamp) }

  scenario "As a guest I can view playlists" do
    visit playlists_path

    expect(page).to have_content spotify.title
    expect(page).to have_content spotify.description
    expect(page).to have_link spotify.title, href: spotify.url

    expect(page).to have_content youtube.title
    expect(page).to have_content soundcloud.title
    expect(page).to have_content bandcamp.title

    expect(page).to have_no_css "a.edit"
  end

  scenario "As an admin I can see edit links" do
    login_as users(:admin), scope: :user
    visit playlists_path

    expect(page).to have_css "a.edit"
  end
end
