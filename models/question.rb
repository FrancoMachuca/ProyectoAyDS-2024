require 'active_record'
class Question < ActiveRecord::Base
    self.abstract_class = true

    has_many :users_questions
    has_many :users, through: :users_questions

    belongs_to :level
end
