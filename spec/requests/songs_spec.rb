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
    it "does not route to actions the controller lacks" do
      expect(get: "/songs/new").not_to be_routable
      expect(post: "/songs").not_to be_routable
      expect(delete: "/songs/some-song").not_to be_routable
    end
  end
end
