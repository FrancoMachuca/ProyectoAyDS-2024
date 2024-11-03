# frozen_string_literal: true

require 'active_record'
class Lesson < ActiveRecord::Base
  include Playable
end
