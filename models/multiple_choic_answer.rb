require 'active_record'

class MultipleChoiceAnswer < ActiveRecord::Base
  belongs_to :multiple_choice
end
