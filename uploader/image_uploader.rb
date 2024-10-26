# frozen_string_literal: true

require 'carrierwave/processing/vips'

# Image uploader moodel
class ImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::Vips
  storage :file

  process resize_to_fill: [142, 150]
  def filename
    @random_token = Digest::SHA2.hexdigest("#{Time.now.utc}--#{model.id}").first(20)
    @filename ||= @random_token.to_s + ".#{file.extension}"
  end

  def content_type_allowlist
    %r{image/}
  end
end
