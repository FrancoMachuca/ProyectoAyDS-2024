require 'active_record'
class User < ActiveRecord::Base
    has_many :user_levels, dependent: :destroy
    has_many :levels, through: :user_levels
    has_one :image
end
