RSpec.feature 'As a guest'  do
  let(:song) { songs(:hotel_california) }
  let(:song_2) { songs(:taki_taki) }

  before do
    visit songs_path
  end

  scenario 'I can view songs' do
    click_on song.title
    expect(page).to have_content song.title
    expect(page).to have_content song.alternate_title
    expect(page).to have_content song.composer
    expect(page).to have_content song.lyrics
    expect(page).to have_content song.translation
    expect(page).to have_content song.categories.map(&:name).to_sentence
    # expect(page).not_to have_content chords
    # expect(page).to have_content formatted_chords
  end

  scenario 'I can search for songs' do
    fill_in 'Search titles...', with: 'California'
    click_on 'Search'
    expect(page).to have_content 'Hotel California'
    expect(page).not_to have_content song_2.title
  end
end
