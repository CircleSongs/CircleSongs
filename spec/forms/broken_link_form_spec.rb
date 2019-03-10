RSpec.describe BrokenLinkForm do
  let(:song) { songs(:hotel_california) }
  let(:recording) { song.recordings.first }
  let(:params) do
    { recording_id: recording.id }
  end
  let(:broken_link_form) { described_class.new(params) }

  describe '#headers[:message]' do
    it 'has the song name' do
      expect(broken_link_form.headers[:message]).to match song.title
    end

    it 'has the recording name' do
      expect(broken_link_form.headers[:message]).to match recording.title
    end

    it 'has the recording link' do
      expect(broken_link_form.headers[:message]).to match recording.url
    end
  end

  describe '#headers[:subject]' do
    it 'has the song name' do
      expect(broken_link_form.headers[:subject]).to eq(
        I18n.t('broken_link_forms.email.subject', title: song.title)
      )
    end
  end
end
