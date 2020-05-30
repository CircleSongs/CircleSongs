RSpec.describe ChordForm do
  let(:chord_form) { described_class.new(attrs) }
  let(:attrs) do
    {
      chord: chord,
      fingering: fingering
    }
  end
  let(:chord) { 'Am7' }
  let(:valid_fingering) do
    <<-JSON
      {
        "chord": [
          [1, 2],
          [2, 1],
          [3, 2],
          [4, 0],
          [5, "x"],
          [6, "x"]
        ],
        "position": 5,
        "barres": [{ "fromString": 5, "toString": 1, "fret": 1 }]
      }
    JSON
  end
  let(:invalid_fingering) do
    <<-JSON
      {
        chord: [
          [1, 2],
          [2, 1],
          [3, 2],
          [4, 0],
          [5, "x"],
          [6, "x"]
        ],
        "position": 5,
        "barres": [{ "fromString": 5, "toString": 1, "fret": 1 }]
      }
    JSON
  end
  let(:fingering) { valid_fingering }

  it { is_expected.to validate_presence_of :chord }
  it { is_expected.to validate_presence_of :fingering }

  describe '#fingering' do
    context 'with valid JSON' do
      it 'returns true' do
        expect(chord_form).to be_valid
      end
    end

    context 'with invalid JSON' do
      let(:fingering) do
        invalid_fingering
      end

      it 'returns false' do
        expect(chord_form).not_to be_valid
      end
    end
  end
end
