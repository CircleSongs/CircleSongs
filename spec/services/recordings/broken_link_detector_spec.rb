require "rails_helper"

RSpec.describe Recordings::BrokenLinkDetector do
  let(:recording) { recordings(:hotel_california_soundclound) }
  let(:url_checker) { instance_double(Recordings::UrlChecker) }
  let(:service) { described_class.new(url_checker: url_checker) }

  describe "#call" do
    context "when all URLs are accessible" do
      before do
        allow(url_checker).to receive(:call).and_return(true)
      end

      it "sets reported to false" do
        service.call(recording)
        expect(recording.reload.reported).to be false
      end

      it "returns false" do
        expect(service.call(recording)).to be false
      end
    end

    context "when external_media_url is broken" do
      before do
        allow(url_checker).to receive(:call).with(recording.external_media_url).and_return(false)
        allow(url_checker).to receive(:call).with(recording.url).and_return(true)
      end

      it "sets reported to true" do
        service.call(recording)
        expect(recording.reload.reported).to be true
      end

      it "returns true" do
        expect(service.call(recording)).to be true
      end
    end

    context "when url is broken" do
      before do
        allow(url_checker).to receive(:call).with(recording.external_media_url).and_return(true)
        allow(url_checker).to receive(:call).with(recording.url).and_return(false)
      end

      it "sets reported to true" do
        service.call(recording)
        expect(recording.reload.reported).to be true
      end

      it "returns true" do
        expect(service.call(recording)).to be true
      end
    end

    context "when recording has no URLs to check" do
      let(:recording) do
        rec = Recording.new(song: songs(:hotel_california), title: "No URLs", external_media_url: "https://example.com")
        rec.save!(validate: false)
        rec.update_columns(external_media_url: nil, url: nil)
        rec
      end

      it "sets reported to false" do
        service.call(recording)
        expect(recording.reload.reported).to be false
      end
    end

    context "when URL check raises an error" do
      before do
        allow(url_checker).to receive(:call).and_return(false)
      end

      it "sets reported to true" do
        service.call(recording)
        expect(recording.reload.reported).to be true
      end
    end
  end
end
