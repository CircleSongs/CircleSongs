require "image_processing/mini_magick"

class ImageUploader < Shrine
  plugin :derivatives
  plugin :versions
  plugin :remove_attachment

  process(:store) do |io, _context|
    versions = { original: io } # retain original

    io.download do |original|
      pipeline = ImageProcessing::MiniMagick.source(original)

      versions[:large] = pipeline.resize_to_limit!(1000, 400)
      versions[:thumb] = pipeline.resize_to_limit!(100, 100)
    end

    versions # return the hash of processed files
  end

  def generate_location(io, record: nil, derivative: nil, **)
    if record
      "#{record.id}/#{derivative}/#{super}"
    else
      super
    end
  end
end
