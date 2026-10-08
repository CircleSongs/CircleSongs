require 'rails_helper'

RSpec.describe 'Home' do
  it 'renders html' do
    get root_path
    expect(response).to have_http_status(:ok)
  end

  it 'returns 406 for non-html formats instead of raising a missing partial' do
    get root_path(format: :json)
    expect(response).to have_http_status(:not_acceptable)
  end
end
