RSpec.describe "Playlists" do
  let(:spotify) { playlists(:spotify) }
  let(:youtube) { playlists(:youtube) }
  let(:soundcloud) { playlists(:soundcloud) }
  let(:bandcamp) { playlists(:bandcamp) }

  scenario "As a guest I can view playlists" do
    visit playlists_path

    expect(page).to have_text spotify.title
    expect(page).to have_link spotify.title, href: spotify.url

    expect(page).to have_text youtube.title
    expect(page).to have_text soundcloud.title
    expect(page).to have_text bandcamp.title
  end
end
