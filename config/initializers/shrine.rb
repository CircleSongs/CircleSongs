require "shrine"
require "shrine/storage/s3"
require "shrine/storage/file_system"
require "shrine/storage/memory"

s3_options = {
  bucket: Rails.application.credentials.aws[:s3_bucket_name],
  access_key_id: Rails.application.credentials.aws[:access_key_id],
  secret_access_key: Rails.application.credentials.aws[:secret_access_key],
  region: Rails.application.credentials.aws[:region]
}

Shrine.storages = if Rails.env.production?
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
                      cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
                      store: Shrine::Storage::FileSystem.new("public", prefix: "uploads")        # permanent
                    }
                  end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
