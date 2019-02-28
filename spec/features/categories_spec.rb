RSpec.feature 'As a guest' do
  before do
    visit root_path
  end

  scenario 'I can see category counts beside the category name' do
    select 'Traditional (1)'
  end

end
