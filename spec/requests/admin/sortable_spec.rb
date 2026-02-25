require "rails_helper"

RSpec.describe "Admin sortable endpoints", type: :request do
  let(:admin) { users(:admin) }

  before do
    login_as admin, scope: :user
  end

  describe "POST /admin/categories/sort" do
    let(:popular) { categories(:popular) }
    let(:traditional) { categories(:traditional) }
    let(:sacred) { categories(:sacred) }

    it "reorders categories by position" do
      post "/admin/categories/sort", params: { ids: [sacred.id, traditional.id, popular.id] }

      expect(response).to have_http_status(:ok)
      expect(sacred.reload.position).to eq 1
      expect(traditional.reload.position).to eq 2
      expect(popular.reload.position).to eq 3
    end
  end

  describe "POST /admin/playlists/sort" do
    let(:spotify) { playlists(:spotify) }
    let(:youtube) { playlists(:youtube) }
    let(:soundcloud) { playlists(:soundcloud) }

    it "reorders playlists by position" do
      post "/admin/playlists/sort", params: { ids: [soundcloud.id, youtube.id, spotify.id] }

      expect(response).to have_http_status(:ok)
      expect(soundcloud.reload.position).to eq 1
      expect(youtube.reload.position).to eq 2
      expect(spotify.reload.position).to eq 3
    end
  end
end
