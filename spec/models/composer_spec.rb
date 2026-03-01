RSpec.describe Composer do
  subject(:composer) { described_class.new(attributes) }

  let(:attributes) do
    {
      name: name,
      url: url
    }
  end
  let(:name) { Faker::Name.name }
  let(:url) { Faker::Internet.url }

  it { is_expected.to have_many(:songs).dependent(:nullify) }

  describe "validations" do
    context "when both name and url are blank" do
      let(:name) { nil }
      let(:url) { nil }

      before { composer.valid? }

      it { is_expected.not_to be_valid }

      it "has the correct error message" do
        expect(composer.errors[:base]).to include("Name or URL must be present")
      end
    end

    context "with only name" do
      let(:url) { nil }

      it { is_expected.to be_valid }
    end

    context "with only url" do
      let(:name) { nil }

      it { is_expected.to be_valid }
    end

    context "with duplicate name" do
      before do
        described_class.create! attributes
      end

      it { is_expected.not_to be_valid }

      it "has the correct error message" do
        composer.valid?

        expect(composer.errors[:name]).to include("has already been taken")
      end
    end

    context "with invalid url" do
      let(:url) { "not-a-url" }

      it { is_expected.not_to be_valid }
    end
  end

  describe "#name" do
    let(:name) { "  #{Faker::Name.name}  " }

    it "strips whitespace from the name" do
      expect(composer.name).to eq name.strip
    end
  end

  describe ".ransackable_attributes" do
    it "returns the correct attributes" do
      expect(described_class.ransackable_attributes).to match_array(%w[created_at id name songs_count url created_by_id updated_by_id])
    end
  end

  describe ".ransackable_associations" do
    it "returns the correct values" do
      expect(described_class.ransackable_associations).to match_array(%w[songs created_by updated_by])
    end
  end
end
