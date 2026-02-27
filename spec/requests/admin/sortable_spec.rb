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

  describe "POST /admin/songs/:id/sort_recordings" do
    let(:song) { songs(:hotel_california) }
    let(:r1) { recordings(:hotel_california_soundclound) }
    let(:r2) { recordings(:hotel_california_the_eagles) }
    let(:r3) { recordings(:hotel_california_spotify) }
    let(:r4) { recordings(:hotel_california_bandcamp) }

    before do
      [r1, r2, r3, r4].each_with_index { |r, i| r.update_column(:position, i + 1) }
    end

    it "reorders recordings by position" do
      post sort_recordings_admin_song_path(song), params: { ids: [r3.id, r1.id, r4.id, r2.id] }

      expect(response).to have_http_status(:ok)
      expect(r3.reload.position).to eq 1
      expect(r1.reload.position).to eq 2
      expect(r4.reload.position).to eq 3
      expect(r2.reload.position).to eq 4
    end

    it "persists order across page loads" do
      post sort_recordings_admin_song_path(song), params: { ids: [r3.id, r1.id, r4.id, r2.id] }

      get admin_song_path(song)
      expect(response).to have_http_status(:ok)
      expect(response.body).to match(/#{r3.title}.*#{r1.title}.*#{r4.title}.*#{r2.title}/m)
    end
  end
end
