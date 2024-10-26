# frozen_string_literal: true

require 'active_record'
require '.\uploader\image_uploader'
require '.\uploader\seed_image_uploader'
class Image < ActiveRecord::Base
  mount_uploader :image, ImagesUploader
  has_many :users, dependent: :nullify
end
