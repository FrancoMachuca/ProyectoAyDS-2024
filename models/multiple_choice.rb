require 'active_record'
class Multiple_choice < Question
    has_many :questions, :foreign_key => "question_id", :class_name => "Question"
end
