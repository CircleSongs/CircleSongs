require "rails_helper"

RSpec.describe Recordings::BrokenLinkDetectorDispatcherJob, type: :job do
  describe "#perform" do
    context "when recording_ids are provided" do
      let(:recording_ids) { [recordings(:hotel_california_soundclound).id, recordings(:hotel_california_the_eagles).id] }

      it "enqueues a job for each recording" do
        recording_ids.each do |id|
          expect(Recordings::BrokenLinkDetectorJob).to receive(:perform_later).with(id)
        end

        described_class.perform_now(recording_ids)
      end
    end

    context "when no recording_ids are provided" do
      it "enqueues a job for all recordings" do
        all_ids = Recording.pluck(:id)

        all_ids.each do |id|
          expect(Recordings::BrokenLinkDetectorJob).to receive(:perform_later).with(id)
        end

        described_class.perform_now
      end
    end
  end
end
