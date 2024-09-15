require 'carrierwave/processing/vips'
class ImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::Vips
  storage :file

  process resize_to_fill: [142, 150]

  def filename
    (Image.ids.empty? ? 1 : Image.ids.max + 1).to_s + ".#{file.extension}"
  end

  def content_type_allowlist
    /image\//
  end

end