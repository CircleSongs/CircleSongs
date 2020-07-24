RSpec.describe Vocabulary do
  let(:result) { described_class.alphabetical }

  it { is_expected.to validate_presence_of :text }
  it { is_expected.to validate_presence_of :translation }

  describe '.alphabetical' do
    it 'returns accented characters in alphabetical order' do
      expect(result.map(&:text)).to eq ['árbol', 'cosas', 'fútbol', 'único']
    end
  end
end
