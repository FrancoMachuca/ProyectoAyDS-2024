# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

require '.\models\player'
require '.\models\level'
require '.\models\player_level'
# Esta clase se encarga de realizar todas las operaciones relacionadas con la modificación
# y consulta del progreso de los usuarios, tanto en niveles particulares como en general.
class GameDataManager
  def create_game_data_for(player: Player)
    PlayerLevel.create(player: player, level: Level.first, playerLevelScore: 0)
  end

  def get_game_data_of(player: Player)
    PlayerLevel.where(player: player)
  end

  def get_total_score_of(player: Player)
    get_game_data_of(player: player).sum('playerLevelScore')
  end

  def get_amount_of_levels_completed(player: Player)
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

  def completed_level?(level: Level, player: Player)
    return false unless unlocked_level?(level: level, player: player)

    row = PlayerLevel.find_by(player: player, level: level)
    return row.playerLevelScore >= row.level.exam.minScore if row.level.playable_type == 'Exam'


    row.playerLevelScore.positive?
  end

  def unlocked_level?(level: Level, player: Player)
    row = PlayerLevel.find_by(player: player, level: level)
    !row.nil?
  end

  def unlock_next_level_for(player: Player, possibly_completed: Level)
    if completed_level?(level: possibly_completed, player: player)
      next_level = Level.where('id > ?', possibly_completed.id).first
      if next_level
        PlayerLevel.create(player: player, level: next_level, playerLevelScore: 0)
        return true
      end
    end
    false
  end

  def add_player_level_score(player: Player, level: Level, value: int)
    row = PlayerLevel.find_by(player: player, level: level)
    return unless row

    row.update(playerLevelScore: value)
  end

  def reset_player_level_score(player: Player, level: Level)
    add_player_level_score(player: player, level: level, value: 0)
  end

  def get_player_rank(player: Player)
    all_users = Player.all
    user_scores = all_users.map { |u| [u, get_total_score_of(player: u)] }
    sorted_user_scores = user_scores.sort_by { |_, score| -score }

    sorted_user_scores.each_with_index do |(u, _), index|
      return index + 1 if u.id == player.id
    end
    nil # En caso de que el usuario no se encuentre
  end
end

# rubocop:enable Metrics/MethodLength
