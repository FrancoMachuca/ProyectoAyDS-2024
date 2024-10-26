# frozen_string_literal: true

require 'active_record'

# Level model
class Level < ActiveRecord::Base
  delegated_type :playable, types: %w[Lesson Exam Tutorial]
  has_many :questions, dependent: :destroy
  has_many :player_levels, dependent: :destroy
  has_many :players, through: :player_levels
end

# Playable type def
module Playable
  extend ActiveSupport::Concern
  included do
    has_one :level, as: :playable, touch: true
  end
end
