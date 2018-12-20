require 'capybara/rails'

RSpec.configure do |config|
  config.before do |example|
    if example.metadata[:js]
      Capybara.current_driver = :webkit
    elsif example.metadata[:selenium]
      Capybara.current_driver = :selenium
    end
  end

  config.after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  config.before(:each, :selenium) do
    Capybara.page.driver.browser.manage.window.maximize
  end
end

require 'support/database_cleaner'
