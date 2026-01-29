# app/uploaders/image_uploader.rb

require "image_processing/mini_magick"

class ImageUploader < Shrine
  plugin :derivatives
  plugin :remove_attachment

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      large: magick.resize_to_limit!(1000, 400),
      thumb: magick.resize_to_limit!(100, 100)
    }
  end

  def generate_location(io, record: nil, derivative: nil, **)
    parts = []

    # Only use record.id if it exists (new records don't have one yet)
    parts << record.id.to_s if record&.id.present?

    # Only include derivative if present
    parts << derivative.to_s if derivative.present?

    parts << super

    # IMPORTANT: must be relative (no leading "/"), otherwise File.join ignores storage directory
    parts.join("/").sub(%r{\A/+}, "")
  end
end
