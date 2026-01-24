RSpec.describe Recording do
  let(:recording) { described_class.new(params) }
  let(:song) { songs(:hotel_california) }
  let(:url) { FFaker::Internet.http_url }
  let(:embedded_player) { FFaker::Lorem.paragraph }
  let(:external_media_url) { "https://soundcloud.com/artist-name/track-name" }
  let(:params) do
    {
      song: song,
      url: url,
      embedded_player: embedded_player,
      external_media_url: external_media_url
    }
  end

  it { is_expected.to belong_to(:song) }

  context "with only url" do
    let(:embedded_player) { nil }
    let(:external_media_url) { nil }

    it "is valid on update" do
      expect(recording).to be_valid(:update)
    end
  end

  context "with only embedded player" do
    let(:url) { nil }
    let(:external_media_url) { nil }

    it "is valid on update" do
      expect(recording).to be_valid(:update)
    end
  end

  context "with only external media url" do
    let(:embedded_player) { nil }
    let(:url) { nil }

    it "is valid on create" do
      expect(recording).to be_valid(:create)
    end

    it "is valid on update" do
      expect(recording).to be_valid(:update)
    end
  end

  describe "#external_media_url" do
    context "with a valid SoundCloud URL" do
      let(:external_media_url) { "https://soundcloud.com/artist-name/track-name" }

      it "is valid" do
        expect(recording).to be_valid
      end
    end

    context "with a valid YouTube URL" do
      let(:external_media_url) { "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }

      it "is valid" do
        expect(recording).to be_valid
      end
    end

    context "on update" do
      before do
        recording.save!
      end

      it "allows empty :external_media_url" do
        recording.update! external_media_url: nil
      end
    end
  end

  describe "#source" do
    context "with a SoundCloud URL" do
      let(:external_media_url) { "https://soundcloud.com/artist/track" }

      it "returns :soundcloud" do
        expect(recording.source).to eq(:soundcloud)
      end
    end

    context "with a YouTube URL" do
      let(:external_media_url) { "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }

      it "returns :youtube" do
        expect(recording.source).to eq(:youtube)
      end
    end

    context "with a Spotify URL" do
      let(:external_media_url) { "https://open.spotify.com/track/4cOdK2wGLETKBW3PvgPWqT" }

      it "returns :spotify" do
        expect(recording.source).to eq(:spotify)
      end
    end

    context "with a Bandcamp URL" do
      let(:external_media_url) { "https://bandcamp.com/EmbeddedPlayer/album=1764593721/track=1396136340" }

      it "returns :bandcamp" do
        expect(recording.source).to eq(:bandcamp)
      end
    end

    context "when no external_media_url" do
      let(:external_media_url) { nil }

      it "returns nil" do
        expect(recording.source).to be_nil
      end
    end
  end

  describe "#formatted_external_media_url" do
    context "with a YouTube URL" do
      let(:external_media_url) { "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }

      it "returns the embed URL" do
        expect(recording.formatted_external_media_url).to eq("https://www.youtube.com/embed/dQw4w9WgXcQ")
      end
    end

    context "with a YouTube URL without www" do
      let(:external_media_url) { "https://youtube.com/watch?v=dQw4w9WgXcQ" }

      it "returns the embed URL" do
        expect(recording.formatted_external_media_url).to eq("https://www.youtube.com/embed/dQw4w9WgXcQ")
      end
    end

    context "with a SoundCloud URL" do
      let(:external_media_url) { "https://soundcloud.com/artist/track" }

      it "returns the player URL" do
        expect(recording.formatted_external_media_url).to include("https://w.soundcloud.com/player/?url=")
        expect(recording.formatted_external_media_url).to include(CGI.escape(external_media_url))
      end
    end

    context "with a Spotify URL" do
      let(:external_media_url) { "https://open.spotify.com/track/4cOdK2wGLETKBW3PvgPWqT" }

      it "returns the URL as-is" do
        expect(recording.formatted_external_media_url).to eq(external_media_url)
      end
    end

    context "with a Bandcamp embed URL" do
      let(:external_media_url) { "https://bandcamp.com/EmbeddedPlayer/album=1764593721/size=large/track=1396136340/foo=bar" }

      it "returns a cleaned embed URL" do
        result = recording.formatted_external_media_url
        expect(result).to include("https://bandcamp.com/EmbeddedPlayer/album=1764593721")
        expect(result).to include("size=small")
        expect(result).to include("track=1396136340")
      end
    end

    context "with an invalid URL" do
      let(:external_media_url) { "https://invalid.com/something" }

      it "returns the original URL" do
        expect(recording.formatted_external_media_url).to eq(external_media_url)
      end
    end

    context "with nil external_media_url" do
      let(:external_media_url) { nil }

      it "returns nil" do
        expect(recording.formatted_external_media_url).to be_nil
      end
    end
  end

  describe "validations" do
    context "with invalid YouTube URL (short format)" do
      let(:external_media_url) { "https://youtu.be/dQw4w9WgXcQ" }
      let(:url) { nil }
      let(:embedded_player) { nil }

      it "is invalid" do
        expect(recording).not_to be_valid
        expect(recording.errors[:external_media_url]).to include("must be a valid SoundCloud, YouTube, Spotify, or Bandcamp URL")
      end
    end

    context "with invalid Spotify URL (album instead of track)" do
      let(:external_media_url) { "https://open.spotify.com/album/4cOdK2wGLETKBW3PvgPWqT" }
      let(:url) { nil }
      let(:embedded_player) { nil }

      it "is invalid" do
        expect(recording).not_to be_valid
        expect(recording.errors[:external_media_url]).to include("must be a valid SoundCloud, YouTube, Spotify, or Bandcamp URL")
      end
    end

    context "with valid Spotify track URL" do
      let(:external_media_url) { "https://open.spotify.com/embed/track/4cOdK2wGLETKBW3PvgPWqT" }
      let(:url) { nil }
      let(:embedded_player) { nil }

      it "is valid" do
        expect(recording).to be_valid
      end
    end

    context "with valid Bandcamp embed URL" do
      let(:external_media_url) { "https://bandcamp.com/EmbeddedPlayer/album=1764593721" }
      let(:url) { nil }
      let(:embedded_player) { nil }

      it "is valid" do
        expect(recording).to be_valid
      end
    end
  end
end
