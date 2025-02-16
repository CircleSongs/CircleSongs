RSpec.describe Category do
  let(:category) { categories(:traditional) }

  it { is_expected.to have_and_belong_to_many(:songs) }
  it { is_expected.to validate_uniqueness_of(:name) }

  describe "#name_and_count" do
    it "returns the number of songs in that category" do
      expect(category.name_and_count).to eq "#{category.name} (#{category.songs.count})"
    end
  end
end
