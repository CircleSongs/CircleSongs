module Recordings
  class UrlChecker
    def initialize(http_client: Faraday.new, logger: Rails.logger)
      @http_client = http_client
      @logger = logger
    end

    def call(url)
      return false if url.blank?

      response = http_client.get(url)
      response.success?
    rescue Faraday::Error => e
      logger.error("Failed to check URL #{url}: #{e.message}")
      false
    end

    private
      attr_reader :http_client, :logger
  end
end
