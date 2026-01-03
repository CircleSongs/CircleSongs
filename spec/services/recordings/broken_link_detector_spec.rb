require "rails_helper"

RSpec.describe Recordings::BrokenLinkDetector do
  let(:recording) { recordings(:hotel_california_soundclound) }
  let(:service) { described_class.new(recording) }

  describe "#call" do
    context "when all URLs are accessible" do
      let(:url_checker) { instance_double(Recordings::UrlChecker) }

      before do
        allow(Recordings::UrlChecker).to receive(:new).and_return(url_checker)
        allow(url_checker).to receive(:call).and_return(true)
      end

      it "sets reported to false" do
        service.call
        expect(recording.reload.reported).to be false
      end

      it "returns false" do
        expect(service.call).to be false
      end
    end

    context "when external_media_url is broken" do
      let(:broken_checker) { instance_double(Recordings::UrlChecker, call: false) }
      let(:working_checker) { instance_double(Recordings::UrlChecker, call: true) }

      before do
        allow(Recordings::UrlChecker).to receive(:new).with(recording.external_media_url).and_return(broken_checker)
        allow(Recordings::UrlChecker).to receive(:new).with(recording.url).and_return(working_checker)
      end

      it "sets reported to true" do
        service.call
        expect(recording.reload.reported).to be true
      end

      it "returns true" do
        expect(service.call).to be true
      end
    end

    context "when url is broken" do
      let(:broken_checker) { instance_double(Recordings::UrlChecker, call: false) }
      let(:working_checker) { instance_double(Recordings::UrlChecker, call: true) }

      before do
        allow(Recordings::UrlChecker).to receive(:new).with(recording.external_media_url).and_return(working_checker)
        allow(Recordings::UrlChecker).to receive(:new).with(recording.url).and_return(broken_checker)
      end

      it "sets reported to true" do
        service.call
        expect(recording.reload.reported).to be true
      end

      it "returns true" do
        expect(service.call).to be true
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
        service.call
        expect(recording.reload.reported).to be false
      end
    end

    context "when URL check raises an error" do
      let(:broken_checker) { instance_double(Recordings::UrlChecker, call: false) }

      before do
        allow(Recordings::UrlChecker).to receive(:new).and_return(broken_checker)
      end

      it "sets reported to true" do
        service.call
        expect(recording.reload.reported).to be true
      end
    end
  end
end
