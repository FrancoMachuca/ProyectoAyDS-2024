# frozen_string_literal: true

require 'active_record'
class Answer < ActiveRecord::Base
  belongs_to :question
end
