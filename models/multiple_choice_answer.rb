require 'active_record'

class MultipleChoiceAnswer < ActiveRecord::Base
  belongs_to :multiple_choice, class_name: 'MultipleChoice', foreign_key: :multiple_choice_id
end
