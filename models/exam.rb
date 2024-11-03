# frozen_string_literal: true

require 'active_record'
class Exam < ActiveRecord::Base
  include Playable
end
