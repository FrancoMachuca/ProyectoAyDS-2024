require 'active_record'
class User < ActiveRecord::Base
    has_many :users_levels, class_name: 'UserLevel'
    has_many :levels, through: :users_levels

    has_many :users_questions
    has_many :questions, through: :users_questions

    def levels_completed
      self.levels.count
    end

    def position
      User.where('totalScore > ?', self.totalScore).count + 1
    end
end
