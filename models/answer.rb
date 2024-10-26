# frozen_string_literal: true

require 'active_record'

# Anwser model
class Answer < ActiveRecord::Base
  belongs_to :question
end
