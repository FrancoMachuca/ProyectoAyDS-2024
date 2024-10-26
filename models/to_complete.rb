# frozen_string_literal: true

require 'active_record'

# ToComplete model
class ToComplete < ActiveRecord::Base
  include Questionable
end
