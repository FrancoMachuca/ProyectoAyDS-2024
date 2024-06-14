require 'active_record'
class User < ActiveRecord::Base
    has_many :user_levels
    has_many :levels, through: :user_levels
end
