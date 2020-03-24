RSpec.describe ContactForm do
  let(:contact_form) { described_class.new(params) }
  let(:params) do
    { name: name }
  end

  describe '::DEFAULT_FROM_EMAIL' do
    it 'returns a sensible default' do
      expect(described_class::DEFAULT_FROM_EMAIL).to eq(
        "contact_form@#{Rails.application.credentials.base_domain}"
      )
    end
  end

  describe '::DEFAULT_FROM_NAME' do
    it 'returns a sensible default' do
      expect(described_class::DEFAULT_FROM_NAME).to eq 'Contact Form'
    end
  end

  describe '::DEFAULT_SUBJECT' do
    it 'returns a sensible default' do
      expect(described_class::DEFAULT_SUBJECT).to eq <<~SUBJECT.strip
        Hi from #{Rails.application.credentials.base_domain}!
      SUBJECT
    end
  end

  describe '#headers[:from]' do
    context 'with a name' do
      let(:name) { FFaker::Name.name }

      it 'returns the name' do
        expect(contact_form.headers[:from]).to match name
      end
    end

    context 'without a name' do
      let(:name) { nil }

      it 'returns the default name' do
        expect(contact_form.headers[:from]).to match ContactForm::DEFAULT_FROM_NAME
      end
    end
  end
end
