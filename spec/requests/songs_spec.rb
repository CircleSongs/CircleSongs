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

    it "ignores unpermitted q keys" do
      get songs_path, params: { q: { lyrics_cont: "x" } }

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
