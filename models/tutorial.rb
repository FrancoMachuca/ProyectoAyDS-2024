# frozen_string_literal: true

require 'active_record'
class Tutorial < ActiveRecord::Base
  include Playable
end
