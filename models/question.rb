require 'active_record'
class Question < ActiveRecord::Base
    has_many :users_questions
    has_many :users, through: :users_questions

    belongs_to :level
end
