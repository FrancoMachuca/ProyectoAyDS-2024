require 'active_record'
class Level < ActiveRecord::Base
    delegated_type :playable, types: %w[ Lesson Exam ]
    has_many :questions
    has_many :user_levels
    has_many :users, through: :user_levels
end

module Playable
    extend ActiveSupport::Concern
    included do
        has_one :level, as: :playable, touch: true
    end
end
