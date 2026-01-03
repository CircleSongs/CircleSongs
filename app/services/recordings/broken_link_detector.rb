module Recordings
  class BrokenLinkDetector
    attr_reader :recording, :url_checker_class

    def initialize(recording, url_checker_class: UrlChecker)
      @recording = recording
      @url_checker_class = url_checker_class
    end

    def call
      broken = check_links
      recording.update_column(:reported, broken)
      broken
    end

    private

    def check_links
      urls_to_check = [recording.external_media_url, recording.url].compact

      return false if urls_to_check.empty?

      urls_to_check.any? { |url| !url_checker_class.new(url).call }
    end
  end
end
