RSpec.feature 'As a guest' do
  scenario 'I can initiate a donation' do
    visit root_path
    click_on 'Make a Donation!'
    expect(page).to have_content 'Love droplet $5.00 USD'
    expect(page).to have_content 'Love potion $10.00 USD'
    expect(page).to have_content 'Love tsunami $25.00 USD'
    expect(page).to have_content 'Love supernova $50.00 USD'
  end
end
