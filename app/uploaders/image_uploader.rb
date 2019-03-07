require 'image_processing/mini_magick'

class ImageUploader < Shrine
  plugin :processing # allows hooking into promoting
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw # delete processed files after uploading

  process(:store) do |io, _context|
    versions = { original: io } # retain original

    io.download do |original|
      pipeline = ImageProcessing::MiniMagick.source(original)

      versions[:large] = pipeline.resize_to_limit!(1000, 400)
      versions[:thumb] = pipeline.resize_to_limit!(100, 100)
    end

    versions # return the hash of processed files
  end

  def generate_location(io, context = {})
    if context[:record]
      "#{context[:record].id}/#{context[:version]}/#{super}"
    else
      super
    end
  end
end
