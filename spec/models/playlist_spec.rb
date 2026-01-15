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
end
