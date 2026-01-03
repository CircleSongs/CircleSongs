module Recordings
  class BrokenLinkDetectorDispatcherJob < ApplicationJob
    queue_as :default

    def perform(recording_ids = nil)
      ids = recording_ids || Recording.pluck(:id)

      ids.each do |recording_id|
        Recordings::BrokenLinkDetectorJob.perform_later(recording_id)
      end
    end
  end
end
