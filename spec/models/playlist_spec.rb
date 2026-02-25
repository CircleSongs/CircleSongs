require 'rails_helper'

RSpec.describe Playlist, type: :model do
  let(:playlist) { described_class.new(params) }
  let(:title) { "Best Circle Songs" }
  let(:description) { "A collection of the best circle songs" }
  let(:url) { "https://open.spotify.com/playlist/37i9dQZF1DXcBWIGoYBM5M" }
  let(:params) do
    {
      title: title,
      description: description,
      url: url
    }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:url) }

    context "with a valid Spotify URL" do
      it "is valid" do
        expect(playlist).to be_valid
      end
    end

    context "with a valid YouTube URL" do
      let(:url) { "https://www.youtube.com/playlist?list=PLrAXtmErZgOeiKm4sgNOknGvNjby9efdf" }

      it "is valid" do
        expect(playlist).to be_valid
      end
    end

    context "with a valid SoundCloud URL" do
      let(:url) { "https://soundcloud.com/artist-name/sets/playlist-name" }

      it "is valid" do
        expect(playlist).to be_valid
      end
    end

    context "with a valid Bandcamp URL" do
      let(:url) { "https://bandcamp.com/playlist/1764593721" }

      it "is valid" do
        expect(playlist).to be_valid
      end
    end

    context "with an invalid URL" do
      let(:url) { "https://invalid.com/playlist" }

      it "is invalid" do
        expect(playlist).not_to be_valid
      end

      it "has a validation error" do
        playlist.valid?

        expect(playlist.errors[:url].first).to include "must be from"
      end
    end
  end

  describe "#service" do
    context "with a Spotify URL" do
      let(:url) { "https://open.spotify.com/playlist/37i9dQZF1DXcBWIGoYBM5M" }

      it "returns spotify" do
        expect(playlist.service).to eq("spotify")
      end
    end

    context "with a YouTube URL" do
      let(:url) { "https://www.youtube.com/playlist?list=PLrAXtmErZgOeiKm4sgNOknGvNjby9efdf" }

      it "returns youtube" do
        expect(playlist.service).to eq("youtube")
      end
    end

    context "with a SoundCloud URL" do
      let(:url) { "https://soundcloud.com/artist-name/sets/playlist-name" }

      it "returns soundcloud" do
        expect(playlist.service).to eq("soundcloud")
      end
    end

    context "with a Bandcamp URL" do
      let(:url) { "https://bandcamp.com/EmbeddedPlayer/album=1764593721" }

      it "returns bandcamp" do
        expect(playlist.service).to eq("bandcamp")
      end
    end

    context "with an invalid URL" do
      let(:url) { "https://invalid.com/playlist" }

      it "returns nil" do
        expect(playlist.service).to be_nil
      end
    end

    context "with a nil URL" do
      let(:url) { nil }

      it "returns nil" do
        expect(playlist.service).to be_nil
      end
    end
  end

  describe "default_scope" do
    it "orders by position" do
      expect(described_class.all.to_sql).to include("ORDER BY")
      expect(described_class.all.to_sql).to include("position")
    end
  end
end
