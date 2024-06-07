require 'active_record'
class Level < ActiveRecord::Base
    delegated_type :playable, types: %w[ Lesson Exam ]
    has_many :questions
    has_one :ranking
end

module Playable
    extend ActiveSupport::Concern
    included do
        has_one :question, as: :playable, touch: true
    end
end
