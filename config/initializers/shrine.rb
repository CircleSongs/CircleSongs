require 'shrine'
require 'shrine/storage/s3'
require 'shrine/storage/file_system'

s3_options = {
  bucket:            ENV['aws_s3_bucket_name'],
  access_key_id:     ENV['aws_access_key_id'],
  secret_access_key: ENV['aws_secret_access_key'],
  region:            ENV['aws_region']
}

if Rails.env.production?
  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: 'uploads/cache', **s3_options),
    store: Shrine::Storage::S3.new(prefix: 'uploads', **s3_options)
  }
else
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'), # temporary
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads')        # permanent
  }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
