Rack::MiniProfiler.config.position = 'bottom-right'
Rack::MiniProfiler.config.start_hidden = true

Rack::MiniProfiler.config.authorization_mode = :allow_authorized if Rails.env.production?
