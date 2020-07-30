RSpec.feature 'As a guest' do
  let(:song) { songs(:hotel_california) }

  before do
    visit song_path(song)
  end

  context 'with no composer link' do
    before do
      song.update! composer_url: ''
    end

    scenario 'if I do not add a #composer_link there is no link' do
      expect(page).not_to have_link(song.composer, href: '')
      expect(page).to have_content song.composer
    end
  end

  scenario 'I can visit a song via its slug' do
    visit "/songs/#{song.slug}"
    expect(page).to have_content song.title
    visit songs_path
    click_on song.title
    expect(current_path).to match Regexp.new(song.slug.to_s)
  end
end
