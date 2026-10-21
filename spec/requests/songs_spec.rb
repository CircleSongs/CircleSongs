require "rails_helper"

RSpec.describe "Songs" do
  describe "GET /songs" do
    it "ignores a non-hash q param" do
      get songs_path, params: { q: "amazing" }

      expect(response).to have_http_status(:ok)
    end

    it "accepts array values for the _in predicates" do
      get songs_path, params: { q: { languages_id_in: [languages(:english).id] } }

      expect(response).to have_http_status(:ok)
    end

    it "ignores non-UUID values for the id _in predicates" do
      probe = "#{categories(:sacred).id}%' AND EXTRACTVALUE(1201,CONCAT(0x7e,1,0x7e))-- -"

      get songs_path, params: { q: { categories_id_in: probe, languages_id_in: [probe, languages(:english).id] } }

      expect(response).to have_http_status(:ok)
    end

    it "ignores unpermitted q keys" do
      get songs_path, params: { q: { lyrics_cont: "x" } }

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /songs/:id" do
    let(:song) { Song.create!(title: "El Condor Pasa Again") }

    it "permanently redirects a previous slug to the current one" do
      old_slug = song.slug
      song.update!(title: "El Condor Vuela")

      get song_path(old_slug)

      expect(response).to redirect_to(song_path("el-condor-vuela"))
      expect(response).to have_http_status(:moved_permanently)
    end

    it "serves a song that has no slug at its id" do
      song = songs(:el_condor_pasa)

      get song_path(song)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "unsupported routes" do
    {
      post: "/songs",
      get: "/songs/some-song/edit",
      patch: "/songs/some-song",
      delete: "/songs/some-song"
    }.each do |verb, path|
      it "does not route #{verb.upcase} #{path}" do
        expect { Rails.application.routes.recognize_path(path, method: verb) }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end
end
