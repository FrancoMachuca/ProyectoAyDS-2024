require 'carrierwave/processing/vips'
class SeedImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::Vips
  storage :file

  process resize_to_fill: [142, 150]

  def content_type_allowlist
    /image\//
  end
end