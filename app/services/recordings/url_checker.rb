module Recordings
  class UrlChecker
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def call
      return false if url.blank?

      uri = URI.parse(url)
      response = Net::HTTP.get_response(uri)
      response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPRedirection)
    rescue StandardError => e
      Rails.logger.error("Failed to check URL #{url}: #{e.message}")
      false
    end
  end
end
