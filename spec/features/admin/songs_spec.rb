RSpec.describe 'As an admin user' do
  let(:user) { users(:admin) }
  let(:title) { FFaker::Music.song }
  let(:chord_form) { 'C#m7 (x46454)' }

  before do
    login_as user
  end

  scenario 'I can add a song' do
    visit admin_songs_path
    click_on 'New Song'
    fill_in 'Title', with: title
    fill_in 'Chord forms', with: chord_form
    click_on 'Create Song'
    expect(page).to have_content 'Song was successfully created.'
    expect(page).to have_content chord_form
  end

  scenario 'I see an edit link on the public index page' do
    visit songs_path
    expect(page).to have_selector 'a.edit'
    expect(page).to have_selector '.has-recording'
  end
end
