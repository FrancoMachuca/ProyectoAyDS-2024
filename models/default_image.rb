# frozen_string_literal: true

require 'active_record'
require '.\uploader\image_uploader'
require '.\uploader\seed_image_uploader'

# The default image for profiles
class DefaultImage < Image
  mount_uploader :image, SeedImagesUploader
end
