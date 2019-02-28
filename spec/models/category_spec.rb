RSpec.describe Category do
  it { is_expected.to have_and_belong_to_many(:songs) }

  let(:category) { categories(:traditional) }

  describe '#name_and_count' do
    it 'returns the number of songs in that category' do
      expect(category.name_and_count).to eq "#{category.name} (#{category.songs.count})"
    end
  end
end
