# frozen_string_literal: true

require 'active_record'

# Question model
class Question < ActiveRecord::Base
  belongs_to :level
  has_many :answers, dependent: :destroy
  delegated_type :questionable, types: %w[MultipleChoice ToComplete Translation MouseTranslation FallingObject],
                                dependent: :destroy
  accepts_nested_attributes_for :questionable
end

# Questionable type def
module Questionable
  extend ActiveSupport::Concern
  included do
    has_one :question, as: :questionable, touch: true
  end
end
