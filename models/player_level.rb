require 'active_record'
class PlayerLevel < ActiveRecord::Base
  belongs_to :player
  belongs_to :level
end
