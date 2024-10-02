require '.\models\player'
require '.\models\level'
require '.\models\player_level'
# Esta clase se encarga de realizar todas las operaciones relacionadas con la modificación
# y consulta del progreso de los usuarios, tanto en niveles particulares como en general.
class GameDataManager

    def createGameDataFor(player: Player)
        UserLevel.create(player: player, level: Level.first, playerLevelScore: 0)
    end

    def getGameDataOf(player: Player)
        return PlayerLevel.where(player: player)
    end
    
    def getTotalScoreOf(player: Player)
        return getGameDataOf(player: player).sum('playerLevelScore')
    end

    def getAmountOfLevelsCompleted(user: Player)
        u = PlayerLevel.where(player: user)
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

    def completedLevel?(level: Level, player: Player)
        if unlockedLevel?(level: level, player: player)
            row = PlayerLevel.find_by(player: player, level: level)
            if row.level.playable_type == "Exam"
                return row.userLevelScore >= row.level.exam.minScore
            else
                return row.userLevelScore > 0
            end
        else
            return false
        end
    end

    def unlockedLevel?(level: Level, player: Player)
        row = PlayerLevel.find_by(user: player, level: level)
        return !row.nil?
    end

    def unlockNextLevelFor(player: Player, possiblyCompleted: Level)
        if completedLevel?(level: possiblyCompleted, Player: player)
            nextLevel = Level.where("id > ?", possiblyCompleted.id).first
            if nextLevel
                PlayerLevel.create(player: player, level: nextLevel, playerLevelScore: 0)
                return true
            end
        end
        return false
    end

    def addPlayerLevelScore(player: Player, level: Level, value: int)
        row = PlayerLevel.find_by(player: player, level: level)
        if row
            row.update(playerLevelScore: value)
        end
    end

    def resetUserLevelScore(player: Player, level: Level)
        addPlayerLevelScore(player: player, level: level, value: 0)
    end

    def getUserRank(player: Player)
        all_users = Player.all
        user_scores = all_users.map { |u| [u, getTotalScoreOf(player: u)] }
        sorted_user_scores = user_scores.sort_by { |_, score| -score }

        sorted_user_scores.each_with_index do |(u, _), index|
            return index + 1 if u.id == player.id
        end
        nil # En caso de que el usuario no se encuentre
    end

end
