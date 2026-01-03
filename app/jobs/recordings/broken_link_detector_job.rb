module Recordings
  class BrokenLinkDetectorJob < ApplicationJob
    queue_as :default

    def perform(recording_id)
      return unless recording = Recording.find_by(id: recording_id)

      Recordings::BrokenLinkDetector.new.call recording
    end
  end
end
