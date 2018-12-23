RSpec.feature 'As an admin user' do
  let(:user) { users(:admin) }
  let(:title) { FFaker::Music.song }
  let(:alternate_title) { FFaker::Music.song }
  let(:composer) { FFaker::Music.song }
  let(:lyrics) { FFaker::Music.song }
  let(:translation) { FFaker::Music.song }
  let(:chords) { 'Swing [D]low, sweet [G]chari[D]ot' }
  let(:formatted_chords) { 'Swing low, sweet chariot' }

  before do
    login
    visit admin_songs_path
  end

  scenario 'I can create CmsPages' do
    click_on 'New Song'
    fill_in 'Title', with: title
    fill_in 'Alternate title', with: alternate_title
    fill_in 'Composer', with: composer
    fill_in 'Lyrics', with: lyrics
    fill_in 'Translation', with: translation
    fill_in 'Chords', with: chords
    check 'Traditional'
    click_on 'Create Song'
    expect(page).to have_content 'Song was successfully created.'
    expect(page).to have_content title
    expect(page).to have_content alternate_title
    expect(page).to have_content composer
    expect(page).to have_content lyrics
    expect(page).to have_content translation
    expect(page).to have_content 'Traditional'
    # expect(page).not_to have_content chords
    # expect(page).to have_content formatted_chords
  end
end
