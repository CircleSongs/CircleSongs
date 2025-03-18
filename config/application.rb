require_relative "boot"
ENV["RANSACK_FORM_BUILDER"] = "::SimpleForm::FormBuilder"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CircleSongs
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.generators do |g|
      g.test_framework :rspec, views: false
      g.helper false
      g.assets false
      g.helper_specs false
      g.controller_specs false
      g.routing false
      g.view_specs false
      g.orm :active_record, primary_key_type: :uuid
    end

    config.active_support.to_time_preserves_timezone = :zone
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
