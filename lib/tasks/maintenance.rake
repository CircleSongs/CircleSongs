# frozen_string_literal: true

namespace :maintenance do
  desc "Publish maintenance/index.html to S3 for Heroku's MAINTENANCE_PAGE_URL"
  task publish: :environment do
    require "aws-sdk-s3"

    key = "maintenance.html"
    source = Rails.root.join("maintenance/index.html")
    abort "Missing #{source}" unless source.exist?

    # Stamp the publish time so the page can report when maintenance began.
    # Publish immediately before `heroku maintenance:on`.
    started_at = Time.current.utc.iso8601
    body = source.read.sub('data-since=""', %(data-since="#{started_at}"))

    aws = Rails.application.credentials.aws
    bucket = aws.fetch(:s3_bucket_name)
    region = aws.fetch(:region)

    Aws::S3::Client.new(
      access_key_id: aws.fetch(:access_key_id),
      secret_access_key: aws.fetch(:secret_access_key), region: region
    ).put_object(
      bucket: bucket, key: key, body: body, acl: "public-read",
      content_type: "text/html; charset=utf-8", cache_control: "public, max-age=60"
    )

    # Path-style URL on purpose: dots in the bucket name don't match the
    # wildcard certificate used for virtual-hosted-style URLs.
    url = "https://s3.#{region}.amazonaws.com/#{bucket}/#{key}"

    puts <<~MSG
      Published #{source.basename} (#{body.bytesize} bytes) to #{url}
      Stamped "offline as of" #{started_at} — republish at the start of each window.

      Heroku serves this only while maintenance mode is on. To point at it:
        heroku config:set MAINTENANCE_PAGE_URL=#{url} -a circle-songs
    MSG
  end
end
