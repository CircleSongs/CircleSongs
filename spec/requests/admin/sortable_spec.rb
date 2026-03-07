require "rails_helper"

RSpec.describe "Admin sortable endpoints" do
  let(:admin) { users(:admin) }

  before do
    login_as admin, scope: :user
  end

  describe "POST /admin/categories/sort" do
    let(:popular) { categories(:popular) }
    let(:traditional) { categories(:traditional) }
    let(:sacred) { categories(:sacred) }

    it "reorders categories by position", :aggregate_failures do
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

    it "reorders playlists by position", :aggregate_failures do
      post "/admin/playlists/sort", params: { ids: [soundcloud.id, youtube.id, spotify.id] }

      expect(response).to have_http_status(:ok)
      expect(soundcloud.reload.position).to eq 1
      expect(youtube.reload.position).to eq 2
      expect(spotify.reload.position).to eq 3
    end
  end

  describe "POST /admin/songs/:id/sort_recordings" do
    let(:song) { songs(:hotel_california) }
    let(:soundcloud_rec) { recordings(:hotel_california_soundclound) }
    let(:eagles_rec) { recordings(:hotel_california_the_eagles) }
    let(:spotify_rec) { recordings(:hotel_california_spotify) }
    let(:bandcamp_rec) { recordings(:hotel_california_bandcamp) }

    before do
      # rubocop:disable Rails/SkipsModelValidations
      [soundcloud_rec, eagles_rec, spotify_rec, bandcamp_rec].each_with_index do |r, i|
        r.update_column(:position, i + 1)
      end
      # rubocop:enable Rails/SkipsModelValidations
    end

    it "reorders recordings by position", :aggregate_failures do
      post sort_recordings_admin_song_path(song),
           params: { ids: [spotify_rec.id, soundcloud_rec.id, bandcamp_rec.id, eagles_rec.id] }

      expect(response).to have_http_status(:ok)
      expect(spotify_rec.reload.position).to eq 1
      expect(soundcloud_rec.reload.position).to eq 2
      expect(bandcamp_rec.reload.position).to eq 3
      expect(eagles_rec.reload.position).to eq 4
    end

    it "persists order across page loads", :aggregate_failures do
      post sort_recordings_admin_song_path(song),
           params: { ids: [spotify_rec.id, soundcloud_rec.id, bandcamp_rec.id, eagles_rec.id] }

      get admin_song_path(song)
      expect(response).to have_http_status(:ok)
      expect(response.body).to match(
        /#{spotify_rec.title}.*#{soundcloud_rec.title}.*#{bandcamp_rec.title}.*#{eagles_rec.title}/m
      )
    end
  end
end
