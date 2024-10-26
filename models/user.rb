# frozen_string_literal: true

require 'active_record'
class User < ActiveRecord::Base
  delegated_type :userable, types: %w[Player Admin]
  belongs_to :image
end

module Userable
  extend ActiveSupport::Concern
  included do
    has_one :user, as: :userable, touch: true
  end
end
