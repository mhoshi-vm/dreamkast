require "image_processing/mini_magick"

class AvatarUploader < Shrine

  THUMBNAILS = {
    large:  [300, 300],
    medium: [120, 120],
    small:  [80, 80],
  }

  def generate_location(io, metadata: {}, **options)
    "avatar/#{super}"
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    magick = magick.crop(*file.crop_points)
    THUMBNAILS.transform_values do |(width, height)|
      magick.resize_to_limit!(width, height)
    end
  end

  class UploadedFile
    def crop_points
      metadata.fetch("crop").fetch_values("x", "y", "width", "height")
    end
  end
end
