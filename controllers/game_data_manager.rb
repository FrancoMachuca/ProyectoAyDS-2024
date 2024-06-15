require '.\models\user'
require '.\models\level'
require '.\models\user_level'
# Esta clase se encarga de realizar todas las operaciones relacionadas con la modificación
# y consulta del progreso de los usuarios, tanto en niveles particulares como en general.
class GameDataManager
    def getTotalScoreOf(user: User)
        UserLevel.where(user: user).sum('userLevelScore')
    end

    def getLevelsCompleted(user: User)
        u = UserLevel.where(user: user)
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
        row = UserLevel.find_by(user: user, level: level)
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
        lastLevelUnlocked = UserLevel.where(user: user).last.level
        if completedLevel?(level: lastLevelUnlocked, user: user)
            nextLevel = Level.where("id > ?", lastLevelUnlocked.id).first
            if nextLevel
                UserLevel.create(user: user, level: nextLevel, userLevelScore: 0)
            end
        end
    end

    def addUserLevelScore(user: User, level: Level, value: int)
        row = UserLevel.find_by(user: user, level: level)
        if row
            row.userLevelScore += value
            row.update(userLevelScore: row.userLevelScore)
        end
    end

    def resetUserLevelScore(user: User, level: Level)
        row = UserLevel.find_by(user: user, level: level)
        if row
            row.userLevelScore = 0
        end
    end

    def getLevelScore(user: User, level: Level)
        row = UserLevel.find_by(user: user, level: level)
        if row
            return row.userLevelScore
        end
    end

end
