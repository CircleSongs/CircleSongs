require "capybara/rails"
require "capybara/rspec"

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by(
      :selenium,
      using: ENV.fetch("BROWSER", :headless_chrome).to_sym,
      screen_size: [1400, 1400]
    )
  end
end

Selenium::WebDriver.logger.ignore(:clear_local_storage, :clear_session_storage)
