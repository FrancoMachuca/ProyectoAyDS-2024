# frozen_string_literal: true

require 'carrierwave/processing/vips'

# SeedImagesUploader model
class SeedImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::Vips
  storage :file

  process resize_to_fill: [142, 150]

  def content_type_allowlist
    %r{image/}
  end
end
