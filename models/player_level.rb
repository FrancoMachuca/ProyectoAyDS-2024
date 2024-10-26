# frozen_string_literal: true

require 'active_record'

# PlayerLevel model
class PlayerLevel < ActiveRecord::Base
  belongs_to :player
  belongs_to :level
end
