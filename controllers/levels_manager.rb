# frozen_string_literal: true

require './models/level'

class LevelManager
  def createNewLevel(type: String, name: String, min_score: Int)
    case type
    when 'Lesson'
      Level.create!(name: name, playable: Lesson.create!)
    when 'Tutorial'
      Level.create!(name: name, playable: Tutorial.create!)
    when 'Exam'
      Level.create!(name: name, playable: Exam.create!(minScore: min_score))
    end
  end
end
