# frozen_string_literal: true

require '.\models\player'
require '.\models\level'
require '.\models\player_level'
# Esta clase se encarga de realizar todas las operaciones relacionadas con la modificación
# y consulta del progreso de los usuarios, tanto en niveles particulares como en general.
class GameDataManager
  def createGameDataFor(player: Player)
    PlayerLevel.create(player: player, level: Level.first, playerLevelScore: 0)
  end

  def getGameDataOf(player: Player)
    PlayerLevel.where(player: player)
  end

  def getTotalScoreOf(player: Player)
    getGameDataOf(player: player).sum('playerLevelScore')
  end

  def getAmountOfLevelsCompleted(player: Player)
    u = PlayerLevel.where(player: player)
    sum = 0
    u.each do |row|
      if row.level.playable_type == 'Exam'
        exam = row.level.exam
        sum += 1 if exam.minScore <= row.playerLevelScore
      elsif row.playerLevelScore.positive?
        sum += 1
      end
    end
    sum
  end

  def completedLevel?(level: Level, player: Player)
    return false unless unlockedLevel?(level: level, player: player)

    row = PlayerLevel.find_by(player: player, level: level)
    return row.playerLevelScore >= row.level.exam.minScore if row.level.playable_type == 'Exam'


    row.playerLevelScore.positive?
  end

  def unlockedLevel?(level: Level, player: Player)
    row = PlayerLevel.find_by(player: player, level: level)
    !row.nil?
  end

  def unlockNextLevelFor(player: Player, possiblyCompleted: Level)
    if completedLevel?(level: possiblyCompleted, player: player)
      nextLevel = Level.where('id > ?', possiblyCompleted.id).first
      if nextLevel
        PlayerLevel.create(player: player, level: nextLevel, playerLevelScore: 0)
        return true
      end
    end
    false
  end

  def addPlayerLevelScore(player: Player, level: Level, value: int)
    row = PlayerLevel.find_by(player: player, level: level)
    return unless row

    row.update(playerLevelScore: value)
  end

  def resetPlayerLevelScore(player: Player, level: Level)
    addPlayerLevelScore(player: player, level: level, value: 0)
  end

  def getPlayerRank(player: Player)
    all_users = Player.all
    user_scores = all_users.map { |u| [u, getTotalScoreOf(player: u)] }
    sorted_user_scores = user_scores.sort_by { |_, score| -score }

    sorted_user_scores.each_with_index do |(u, _), index|
      return index + 1 if u.id == player.id
    end
    nil # En caso de que el usuario no se encuentre
  end
end
