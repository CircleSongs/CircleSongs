RSpec.feature 'As a guest', type: :system do
  scenario 'I can initiate a donation' do
    visit root_path
    click_on 'Make a Donation!'
  end
end
