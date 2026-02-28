require "capybara/rails"
require "capybara/rspec"

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless=new")
  options.add_argument("--window-size=1400,1400")
  options.add_argument("--disable-gpu")
  options.add_argument("--no-sandbox")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :headless_chrome
Capybara.save_path = Rails.root.join("tmp/screenshots")

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by(
      :selenium,
      using: ENV.fetch("BROWSER", :headless_chrome).to_sym,
      screen_size: [1400, 1400]
    )
  end

  config.after(:each, type: :system) do |example|
    if example.exception
      save_screenshot("#{example.full_description.parameterize}.png")
    end
  end
end

Selenium::WebDriver.logger.ignore(:clear_local_storage, :clear_session_storage)
