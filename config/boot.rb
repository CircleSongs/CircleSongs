ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

# Per-checkout settings (DB_PORT, PORT, VITE_RUBY_PORT, ...) written by
# bin/services and bin/dev. Real environment variables (e.g. CI) win.
env_local = File.expand_path("../.env.local", __dir__)
if File.exist?(env_local)
  File.foreach(env_local) do |line|
    next if line.strip.empty? || line.start_with?("#")

    key, value = line.strip.split("=", 2)
    next if value.nil?

    ENV[key] ||= value
  end
end
