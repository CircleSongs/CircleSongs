RSpec.feature 'As a guest' do
  let(:song) { songs(:hotel_california) }

  scenario 'I can view a list of songs' do
    visit root_path
    expect(page).to have_content song.title
  end

end
