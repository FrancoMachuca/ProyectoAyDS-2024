require 'active_record'
require '.\uploader\image_uploader.rb'
require '.\uploader\seed_image_uploader.rb'
class Image < ActiveRecord::Base
  mount_uploader :image, ImagesUploader
  has_many :users, dependent: :nullify
end