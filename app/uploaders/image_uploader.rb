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
    if record && record.id.present? && derivative.present?
      "#{record.id}/#{derivative}/#{super}"
    elsif record && record.id.present?
      "#{record.id}/#{super}"
    else
      super
    end
  end
end
