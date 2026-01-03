require "rails_helper"

RSpec.describe Recordings::BrokenLinkDetectorJob, type: :job do
  let(:recording) { recordings(:hotel_california_soundclound) }

  describe "#perform" do
    it "calls BrokenLinkDetector service" do
      detector = instance_double(Recordings::BrokenLinkDetector)
      expect(Recordings::BrokenLinkDetector).to receive(:new).and_return(detector)
      expect(detector).to receive(:call).with(recording)

      described_class.perform_now(recording.id)
    end

    it "handles missing recording gracefully" do
      expect { described_class.perform_now(999999) }.not_to raise_error
    end
  end
end
