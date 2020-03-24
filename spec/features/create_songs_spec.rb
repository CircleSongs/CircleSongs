RSpec.feature 'As an admin user' do
  let(:user) { users(:admin) }
  let(:title) { FFaker::Music.song }
  let(:description) { FFaker::Lorem.paragraphs.join("\n") }
  let(:alternate_title) { FFaker::Music.song }
  let(:composer) { FFaker::Music.song }
  let(:composer_url) { FFaker::Internet.http_url }
  let(:lyrics) { FFaker::Music.song }
  let(:translation) { FFaker::Music.song }
  let(:chords) { 'Swing [D]low, sweet [G]chari[D]ot' }
  let(:formatted_chords) { 'Swing low, sweet chariot' }

  before do
    login
    visit admin_songs_path
  end

  scenario 'I can create a Song', :chrome do
    click_on 'New Song'
    fill_in 'Title', with: title
    fill_in 'Alternate title', with: alternate_title
    fill_in 'Composer', with: composer
    fill_in 'Composer url', with: composer_url
    fill_in 'Lyrics', with: lyrics
    fill_in 'Translation', with: translation
    fill_in 'Chords', with: chords
    fill_in 'Description', with: description
    check 'Traditional'
    check 'English'
    check 'Spanish'
    click_on 'Create Song'
    expect(page).to have_content 'Song was successfully created.'
    expect(page).to have_content title
    expect(page).to have_content alternate_title
    expect(page).to have_link(composer, href: composer_url)
    expect(page).to have_content lyrics
    expect(page).to have_content translation
    expect(page).to have_content description
    expect(page).to have_content 'Traditional'
    expect(page).to have_content 'English and Spanish'
    expect(page).not_to have_content chords
    expect(page).to have_content formatted_chords
  end
end
