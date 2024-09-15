require 'active_record'
require '.\uploader\image_uploader.rb'
class Image < ActiveRecord::Base
  mount_uploader :image, ImagesUploader
  belongs_to :user
end