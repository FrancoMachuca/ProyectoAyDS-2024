require 'active_record'
require '.\models\user.rb'
class UserLevel < ActiveRecord::Base

    belongs_to :user
    belongs_to :level

    def getTotalScoreOf(user: User)
        UserLevel.where(user_id: user.id).sum('userLevelScore')
    end

    def getLevelsCompleted(user: User)
        u = UserLevel.where(user_id: user.id)
        sum = 0
        u.each do |row|
            if row.level.playable_type == "Exam"
                exam = row.level.exam
                if exam.minScore <= row.userLevelScore
                    sum += 1
                end
            else
                if row.userLevelScore > 0
                    sum += 1
                end
            end
        end
        return sum
    end

end