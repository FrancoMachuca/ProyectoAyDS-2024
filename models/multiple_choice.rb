# frozen_string_literal: true

require 'active_record'

# Mutiple_Choice model
class MultipleChoice < ActiveRecord::Base
  include Questionable
end
