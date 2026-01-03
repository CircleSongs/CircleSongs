module Recordings
  class BrokenLinkDetectorJob < ApplicationJob
    queue_as :default

    def perform(recording_id)
      recording = Recording.find(recording_id)
      Recordings::BrokenLinkDetector.new(recording).call
    end
  end
end
