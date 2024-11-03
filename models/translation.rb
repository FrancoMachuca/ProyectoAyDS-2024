# frozen_string_literal: true

require 'active_record'
class Translation < ActiveRecord::Base
  include Questionable
end
