RSpec.feature 'As an admin user' do
  let(:user) { users(:admin) }
  let(:title) { FFaker::Music.song }

  before do
    login
    visit admin_songs_path
  end

  scenario 'I can create CmsPages' do
    click_on 'New Song'
    fill_in 'Title', with: title
    click_on 'Create Song'
    expect(page).to have_content title
  end
end
