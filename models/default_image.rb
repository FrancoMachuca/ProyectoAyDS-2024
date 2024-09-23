require 'active_record'
require '.\uploader\image_uploader.rb'
require '.\uploader\seed_image_uploader.rb'
class DefaultImage < Image
  mount_uploader :image, SeedImagesUploader
end