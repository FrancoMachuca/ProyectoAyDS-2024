# frozen_string_literal: true

require 'active_record'

# User model
class User < ActiveRecord::Base
  delegated_type :userable, types: %w[Player Admin]
  belongs_to :image
end

# Userable type def
module Userable
  extend ActiveSupport::Concern
  included do
    has_one :user, as: :userable, touch: true
  end
end
