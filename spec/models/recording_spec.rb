RSpec.describe Recording do
  let(:recording) { described_class.new(params) }
  let(:song) { songs(:hotel_california) }
  let(:url) { FFaker::Internet.http_url }
  let(:embedded_player) { FFaker::Lorem.paragraph }
  let(:params) do
    {
      song: song,
      url: url,
      embedded_player: embedded_player
    }
  end

  it { is_expected.to belong_to(:song) }

  context "with a url and no embeded player" do
    let(:embedded_player) { nil }

    it "is valid" do
      expect(recording).to be_valid
    end
  end

  context "with no url and an embeded player" do
    let(:url) { nil }

    it "is valid" do
      expect(recording).to be_valid
    end
  end

  context "with no url and no embeded player" do
    let(:embedded_player) { nil }
    let(:url) { nil }

    it "is NOT valid" do
      expect(recording).not_to be_valid
    end
  end
end
