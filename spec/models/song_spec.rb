RSpec.describe Song do
  let(:song) { described_class.new(params) }
  let(:params) do
    {}
  end

  it { is_expected.to have_and_belong_to_many(:languages) }
  it { is_expected.to have_and_belong_to_many(:categories) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe "formatted_chords" do
    let(:params) do
      {
        chords: <<-TEXT
          {title: You Are My Sunshine}

          {c:Verse 1}
          [G]The other night dear as I lay sleeping
          [G7]I dreamed I [C]held you in my [G]arms
          [G7]But when I a[C]woke dear I was mis[G]taken
          So I hung my [D7]head and [G]cried

          {c:Chorus}
          {soc}
          You are my sunshine my only sunshine
          [G7]You make me [C]happy when skies are [G]gray
          [G7]You'll never [C]know dear how much I [G]love you
          Please don't take [D7]my sunshine a[G]way
          {eoc}
        TEXT
      }
    end

    before do
      allow(Chordpro).to receive(:html).and_call_original
    end

    it "calls Chordpro" do
      song.formatted_chords
      expect(Chordpro).to have_received(:html)
    end

    it "returns formatted stuff" do
      expect(song.formatted_chords).to match "<table>"
    end
  end

  describe "slugs" do
    let(:song) { described_class.create!(title: "El Condor Pasa Again") }

    it "regenerates the slug when the title changes" do
      song.update!(title: "El Condor Vuela")

      expect(song.slug).to eq("el-condor-vuela")
    end

    it "still finds the song by its previous slug" do
      old_slug = song.slug
      song.update!(title: "El Condor Vuela")

      expect(described_class.friendly.find(old_slug)).to eq(song)
    end
  end
end
