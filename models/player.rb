require 'active_record'
require './models/user.rb'
class Player < ActiveRecord::Base
  include Userable
  has_many :player_levels, dependent: :destroy
  has_many :levels, through: :player_levels
end