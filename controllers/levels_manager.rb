require './models/level'

class LevelManager
  def createNewLevel(type: String, name: String, min_score: Int)
    case type
    when "Lesson"
      @level = Level.create!(name: name, playable: Lesson.create!())
    when "Tutorial"
      @level = Level.create!(name: name, playable: Tutorial.create!())
    when "Exam"
      @level = Exam.create!(name: name, playable: Exam.create!(minScore: min_score))
    end
    createLevelData(level: @level)
  end

  def createLevelData(level: Level)
    players = Player.all
    players.each do |u|
      PlayerLevel.create!(player: u, level: level, playerLevelScore: 0)
    end
  end
end
