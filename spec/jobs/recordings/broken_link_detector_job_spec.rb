require "rails_helper"

RSpec.describe Recordings::BrokenLinkDetectorJob, type: :job do
  let(:recording) { recordings(:hotel_california_soundclound) }

  describe "#perform" do
    it "calls BrokenLinkDetector service" do
      detector = instance_double(Recordings::BrokenLinkDetector)
      expect(Recordings::BrokenLinkDetector).to receive(:new).with(recording).and_return(detector)
      expect(detector).to receive(:call)

      described_class.perform_now(recording.id)
    end
  end
end
