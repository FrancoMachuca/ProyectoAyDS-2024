require 'active_record'
class Question < ActiveRecord::Base
    belongs_to :multiple_choice, :foreign_key => "question_id", :class_name => "Multiple_choice"
    belongs_to :level
    has_one :answer
end
