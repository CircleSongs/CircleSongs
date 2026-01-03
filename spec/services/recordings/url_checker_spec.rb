require "rails_helper"

RSpec.describe Recordings::UrlChecker do
  describe "#call" do
    let(:http_client) { instance_double(Faraday::Connection) }
    let(:logger) { instance_double(Logger) }
    let(:checker) { described_class.new(http_client: http_client, logger: logger) }

    context "with a valid, accessible URL" do
      let(:url) { "https://example.com" }
      let(:response) { instance_double(Faraday::Response, success?: true) }

      before do
        allow(http_client).to receive(:get).with(url).and_return(response)
      end

      it "returns true" do
        expect(checker.call(url)).to be true
      end
    end

    context "with a URL that redirects" do
      let(:url) { "https://example.com" }
      let(:response) { instance_double(Faraday::Response, success?: true) }

      before do
        allow(http_client).to receive(:get).with(url).and_return(response)
      end

      it "returns true" do
        expect(checker.call(url)).to be true
      end
    end

    context "with a URL that returns 404" do
      let(:url) { "https://example.com/not-found" }
      let(:response) { instance_double(Faraday::Response, success?: false) }

      before do
        allow(http_client).to receive(:get).with(url).and_return(response)
      end

      it "returns false" do
        expect(checker.call(url)).to be false
      end
    end

    context "with a stale/broken URL" do
      let(:url) { "https://soundcloud.com/deleted-track" }
      let(:response) { instance_double(Faraday::Response, success?: false) }

      before do
        allow(http_client).to receive(:get).with(url).and_return(response)
      end

      it "returns false" do
        expect(checker.call(url)).to be false
      end
    end

    context "with a URL that raises an error" do
      let(:url) { "https://example.com/timeout" }

      before do
        allow(http_client).to receive(:get).and_raise(Faraday::TimeoutError.new("Connection timeout"))
        allow(logger).to receive(:error)
      end

      it "returns false" do
        expect(checker.call(url)).to be false
      end

      it "logs the error" do
        expect(logger).to receive(:error).with(/Failed to check URL/)
        checker.call(url)
      end
    end

    context "with a blank URL" do
      let(:url) { "" }

      it "returns false" do
        expect(checker.call(url)).to be false
      end
    end

    context "with a nil URL" do
      let(:url) { nil }

      it "returns false" do
        expect(checker.call(url)).to be false
      end
    end
  end
end
