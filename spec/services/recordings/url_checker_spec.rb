require "rails_helper"

RSpec.describe Recordings::UrlChecker do
  describe "#call" do
    let(:checker) { described_class.new(url) }

    context "with a valid, accessible URL" do
      let(:url) { "https://example.com" }
      let(:success_response) { instance_double(Net::HTTPSuccess) }

      before do
        allow(Net::HTTP).to receive(:get_response).and_return(success_response)
        allow(success_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
        allow(success_response).to receive(:is_a?).with(Net::HTTPRedirection).and_return(false)
      end

      it "returns true" do
        expect(checker.call).to be true
      end
    end

    context "with a URL that redirects" do
      let(:url) { "https://example.com" }
      let(:redirect_response) { instance_double(Net::HTTPRedirection) }

      before do
        allow(Net::HTTP).to receive(:get_response).and_return(redirect_response)
        allow(redirect_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
        allow(redirect_response).to receive(:is_a?).with(Net::HTTPRedirection).and_return(true)
      end

      it "returns true" do
        expect(checker.call).to be true
      end
    end

    context "with a URL that returns 404" do
      let(:url) { "https://example.com/not-found" }
      let(:error_response) { instance_double(Net::HTTPNotFound) }

      before do
        allow(Net::HTTP).to receive(:get_response).and_return(error_response)
        allow(error_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
        allow(error_response).to receive(:is_a?).with(Net::HTTPRedirection).and_return(false)
      end

      it "returns false" do
        expect(checker.call).to be false
      end
    end

    context "with a URL that raises an error" do
      let(:url) { "https://example.com/timeout" }

      before do
        allow(Net::HTTP).to receive(:get_response).and_raise(StandardError.new("Connection timeout"))
      end

      it "returns false" do
        expect(checker.call).to be false
      end

      it "logs the error" do
        expect(Rails.logger).to receive(:error).with(/Failed to check URL/)
        checker.call
      end
    end

    context "with a blank URL" do
      let(:url) { "" }

      it "returns false" do
        expect(checker.call).to be false
      end
    end

    context "with a nil URL" do
      let(:url) { nil }

      it "returns false" do
        expect(checker.call).to be false
      end
    end
  end
end
