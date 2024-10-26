# frozen_string_literal: true

require 'active_record'
require '.\uploader\image_uploader'
require '.\uploader\seed_image_uploader'
class DefaultImage < Image
  mount_uploader :image, SeedImagesUploader
end
