ENV["RAILS_ENV"] ||= "test"

require "spec_helper"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure(&:infer_spec_type_from_file_location!)

require "support/auth_steps"
require "support/devise"
require "support/fixtures"
require "support/helper_methods"
require "support/capybara_drivers"
require "support/mailer_macros"
require "support/shoulda_matchers"

RSpec.configure do |config|
  config.fixture_paths = [Rails.root.join("spec/fixtures").to_s]
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
