# frozen_string_literal: true

require 'active_record'
class To_complete < ActiveRecord::Base
  include Questionable
end
