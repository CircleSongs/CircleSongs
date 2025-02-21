RSpec.describe Composer do
  let(:composer) { described_class.new(params) }
  let(:params) { base_params }
  let(:base_params) { {} }
  let(:valid_name) { Faker::Name.name }
  let(:valid_url) { "https://example.com" }

  it { is_expected.to have_many(:songs).dependent(:nullify) }

  describe "validations" do
    subject { composer }

    # context "when both name and url are blank" do
    #   it "is invalid" do
    #     expect(subject).not_to be_valid
    #     expect(composer.errors[:base]).to include("Name or URL must be present")
    #   end
    # end

    # context "with only name" do
    #   let(:base_params) { { name: valid_name } }

    #   it { is_expected.to be_valid }
    # end

    # context "with only url" do
    #   let(:base_params) { { url: valid_url } }

    #   it { is_expected.to be_valid }
    # end

    # context "with both name and url" do
    #   let(:base_params) { { name: valid_name, url: valid_url } }

    #   it { is_expected.to be_valid }
    # end

    # context "with duplicate name" do
    #   let(:base_params) { { name: valid_name } }

    #   before { described_class.create!(name: valid_name) }

    #   it { is_expected.to validate_uniqueness_of(:name) }
    # end

    # describe "url format" do
    #   let(:base_params) { { url: test_url } }

    #   context "with valid urls" do
    #     [
    #       "http://example.com",
    #       "https://test.com/path",
    #       "https://music.site.com/composer/123"
    #     ].each do |url|
    #       context "when url is #{url}" do
    #         let(:test_url) { url }

    #         it { is_expected.to be_valid }
    #       end
    #     end
    #   end

    #   context "with invalid urls" do
    #     [
    #       "not-a-url",
    #       "ftp://example.com",
    #       "just text",
    #       "http:/missing-slash"
    #     ].each do |url|
    #       context "when url is #{url}" do
    #         let(:test_url) { url }

    #         it { is_expected.not_to be_valid }

    #         it "has the correct error message" do
    #           subject.valid?
    #           expect(subject.errors[:url]).to include("must be a valid URL")
    #         end
    #       end
    #     end
    #   end
    # end
  end

  describe ".ransackable_attributes" do
    subject { described_class.ransackable_attributes }

    it { is_expected.to match_array(%w[created_at id name url]) }
  end

  describe ".ransackable_associations" do
    subject { described_class.ransackable_associations }

    it { is_expected.to match_array(%w[songs]) }
  end
end
