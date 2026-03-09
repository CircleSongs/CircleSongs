require "capybara/rails"
require "capybara/rspec"

# Chrome 145+ raises CDP -32000 "Node with given id does not belong to the
# document" during page transitions. Capybara retries StaleElementReferenceError
# but not this UnknownError variant. Patch the Selenium bridge to re-raise as
# StaleElementReferenceError so Capybara's built-in retry logic handles it.
Selenium::WebDriver::Remote::Bridge.prepend(Module.new do
  def execute(*)
    super
  rescue Selenium::WebDriver::Error::UnknownError => e
    if e.message.include?("does not belong to the document")
      raise Selenium::WebDriver::Error::StaleElementReferenceError, e.message
    end

    raise
  end
end)

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
    save_screenshot("#{example.full_description.parameterize}.png") if example.exception
  end
end

Selenium::WebDriver.logger.ignore(:clear_local_storage, :clear_session_storage)
