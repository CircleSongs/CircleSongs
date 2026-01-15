module Recordings
  class BrokenLinkDetector
    def initialize(url_checker: UrlChecker.new)
      @url_checker = url_checker
    end

    def call(recording)
      broken = [
        recording.external_media_url,
        recording.url
      ].compact.detect { |url| !url_checker.call(url) }

      recording.update_columns(reported: broken.present?)
      broken.present?
    end

    private
      attr_reader :url_checker
  end
end
