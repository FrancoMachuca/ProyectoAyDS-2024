require '.\models\user'
require '.\models\level'
require '.\models\user_level'
# Esta clase se encarga de realizar todas las operaciones relacionadas con la modificación
# y consulta del progreso de los usuarios, tanto en niveles particulares como en general.
class GameDataManager

    def createGameDataFor(user: User)
        UserLevel.create(user: user, level: Level.first, userLevelScore: 0)
    end

    def getGameDataOf(user: User)
        return UserLevel.where(user: user)
    end
    
    def getTotalScoreOf(user: User)
        return getGameDataOf(user: user).sum('userLevelScore')
    end

    def getAmountOfLevelsCompleted(user: User)
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

    def unlockNextLevelFor(user: User, possiblyCompleted: Level)
        if completedLevel?(level: possiblyCompleted, user: user)
            nextLevel = Level.where("id > ?", possiblyCompleted.id).first
            if nextLevel
                UserLevel.create(user: user, level: nextLevel, userLevelScore: 0)
                return true
            end
        end
        return false
    end

    def addUserLevelScore(user: User, level: Level, value: int)
        row = UserLevel.find_by(user: user, level: level)
        if row
            row.update(userLevelScore: value)
        end
    end

    def resetUserLevelScore(user: User, level: Level)
        addUserLevelScore(user: user, level: level, value: 0)
    end

    def getLevelScore(user: User, level: Level)
        row = UserLevel.find_by(user: user, level: level)
        if row
            return row.userLevelScore
        end
    end

    def getUserRank(user: User)
        all_users = User.all
        user_scores = all_users.map { |u| [u, getTotalScoreOf(user: u)] }
        sorted_user_scores = user_scores.sort_by { |_, score| -score }

        sorted_user_scores.each_with_index do |(u, _), index|
            return index + 1 if u.id == user.id
        end
        nil # En caso de que el usuario no se encuentre
    end

end
