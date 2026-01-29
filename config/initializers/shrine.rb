# config/initializers/shrine.rb

require "shrine"
require "shrine/storage/s3"
require "shrine/storage/file_system"
require "shrine/storage/memory"

# ------------------------------------------------------------
# Ensure MiniMagick/ImageMagick use a writable temp directory.
# This prevents weird attempts to write temp files to "/" (EROFS).
# ------------------------------------------------------------
begin
  require "tmpdir"
  require "mini_magick"

  tmpdir = Dir.tmpdir

  # ImageMagick respects this for temp working files
  ENV["MAGICK_TEMPORARY_PATH"] ||= tmpdir

  # Ruby / Tempfile / many libs rely on TMPDIR
  ENV["TMPDIR"] ||= tmpdir

  MiniMagick.configure do |config|
    config.tmpdir = tmpdir
  end
rescue LoadError
  # mini_magick not available in some envs; ignore
end

Shrine.storages =
  if Rails.env.production?
    s3_options = {
      bucket: Rails.application.credentials.dig(:aws, :s3_bucket_name),
      access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
      region: Rails.application.credentials.dig(:aws, :region)
    }

    {
      cache: Shrine::Storage::S3.new(prefix: "uploads/cache", **s3_options),
      store: Shrine::Storage::S3.new(prefix: "uploads", **s3_options)
    }
  elsif Rails.env.test?
    {
      cache: Shrine::Storage::Memory.new,
      store: Shrine::Storage::Memory.new
    }
  else
    {
      cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
      store: Shrine::Storage::FileSystem.new("public", prefix: "uploads")
    }
  end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :determine_mime_type
Shrine.plugin :derivatives, create_on_promote: true, versions_compatibility: true
