require 'active_record'
class Question < ActiveRecord::Base
    belongs_to :level
    has_many :answers, dependent: :destroy
    delegated_type :questionable, types: %w[ Multiple_choice To_complete Translation MouseTranslation FallingObject], dependent: :destroy
    accepts_nested_attributes_for :questionable
end

module Questionable
    extend ActiveSupport::Concern
    included do
        has_one :question, as: :questionable, touch: true
    end
end

