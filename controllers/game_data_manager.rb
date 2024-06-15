require '.\models\user.rb'
require '.\models\level.rb'
require '.\models\user_level.rb'
class GameDataManager 
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

    def completedLevel?(level: Level, user: User)
        row = UserLevel.where(user_id: user.id, level_id: level.id)
        if row 
            if row.level.playable_type == "Exam"
                return row.userLevelScore >= row.level.exam.minScore
            else 
                return row.userLevelScore > 0
            end
        else 
            return false
        end
    end

    def unlockNextLevelFor(user: User)
        lastLevelUnlocked = UserLevel.where(user_id: user.id).last
        if completedLevel?(user, lastLevelUnlocked)
            nextLevel = Level.where("id > " + lastLevelUnlocked.id.to_s).first
            if nextLevel
                user.levels.push(nextLevel)
            end
        end
    end

    
end