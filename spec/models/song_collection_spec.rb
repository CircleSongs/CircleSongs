RSpec.describe SongCollection do
  let(:song_collection) { described_class.new(params: params) }
  let(:params) { {} }
  let(:q) { song_collection.q }
  let(:results) { q.result(distinct: true) }

  describe ".call" do
    context "with no params" do
      it "returns all Songs" do
        expect(results.count).to eq 4
      end
    end

    context "with a good string" do
      let(:params) do
        { title_cont: "California" }
      end

      it "returns songs matching the title" do
        expect(results.count).to eq 1
      end
    end

    context "with a bad string" do
      let(:params) do
        { title_cont: "foo" }
      end

      it "returns no songs" do
        expect(results.count).to eq 0
      end
    end
  end
end
