require './models/question'
require './models/answer'
require './models/level'
require './models/falling_object'
# Esta clase se encarga de administrar las preguntas del juego y sus respuestas, a través de
# métodos que le permiten devolver una vista de un tipo de pregunta determinado,
# determinar si una respuesta a una pregunta es correcta, devolver la pregunta siguiente a otra, entre otros.
class QuestionsManager

  # Devuelve la vista correspondiente a una pregunta según su tipo.
  def show(question: Question)
    case question.questionable_type
    when "Multiple_choice"
      return :multiple_choice
    when "Translation"
      return :translation
    when 'To_complete'
      return :to_complete
    when 'MouseTranslation'
      return :mouse_translation
    when 'FallingObject'
      return :falling_object
    end
  end

  # Método que analiza una respuesta a una pregunta y devuelve un booleano indicando si es correcta o no.
  def correctAnswer?(answer: Answer, question: Question)
    if question.questionable_type == 'Multiple_choice'
      return answer.correct
    elsif question.questionable_type == 'Translation' || question.questionable_type == 'To_complete' || question.questionable_type == 'MouseTranslation' || question.questionable_type == 'FallingObject'
      user_guess = answer.answer.gsub(/\s+/, "").downcase
      correct_phrase = question.answers.find_by(correct: true).answer.gsub(/\s+/, "").downcase
      return user_guess == correct_phrase
    else
      puts "No se reconoce el tipo"
    end
  end

  # Dada una pregunta (question), devuelve la siguiente a ella (que pertenece al mismo nivel). Devuelve nil si question es la última de su nivel.
  def nextQuestion(question: Question)
    question_family = question.level.questions
    actual_question_index = question_family.find_index(question)
    next_question = question_family[actual_question_index + 1]
    return next_question
  end

  def buildPlayerAnswer(answer: String, question: Question)
    return Answer.new(answer: answer, correct: false, question: question)
  end

  def createNewQuestion(question_type: String, options: Array, translation_type: String, key_word: String, key_word_morse: String, correct_answer: String, question_description: String, level: Level)
    if validateParams(question_type: question_type, options: options, translation_type: translation_type, key_word: key_word, key_word_morse: key_word_morse, correct_answer: correct_answer, question_description: question_description, level: level)
      case question_type
      when "Multiple_choice"
        @question = Question.create!(description: question_description, level: level, questionable: Multiple_choice.create!())
        options.each do |op|
          Answer.create!(answer: op[:text], correct: op[:correct], question: @question)
        end
      when "Translation"
        @question = Question.create!(description: question_description, level: level, questionable: Translation.create!())
        Answer.create!(answer: correct_answer, correct: true, question: @question)
      when "To_complete"
        @question = Question.create!(description: question_description, level: level, questionable: To_complete.create!(keyword: key_word, toCompleteMorse: key_word_morse))
        Answer.create!(answer: correct_answer, correct: true, question: @question)
      when "MouseTranslation"
        @question = Question.create!(description: question_description, level: level, questionable: MouseTranslation.create!())
        Answer.create!(answer: correct_answer, correct: true, question: @question)
      when "FallingObject"
        @question = Question.create!(description: question_description, level: level, questionable: FallingObject.create!())
        Answer.create!(answer: correct_answer, correct: true, question: @question)
      end
      return true
    else
      return false
    end
  end

  def validateParams(question_type: String, options: Array, translation_type: String, key_word: String, key_word_morse: String, correct_answer: String, question_description: String, level: Level)
    if Level.exists?(level.id)
      case question_type
      when 'Multiple_choice'
        return (options.size <= 4 and
                options.all? {|elem| !elem[:text].to_s.empty?} and
                options.one? {|elem| elem[:correct]})

      when 'Translation'
        case translation_type
        when 'morse_translation'
          return question_description.match?(/.*[.\-]+.*$/) && correct_answer.match?(/\A[a-zA-ZñÑáéíóúÁÉÍÓÚ0-9 ]+\z/))
        when 'spanish_translation'
          return (question_description.match?(/\A[a-zA-ZñÑáéíóúÁÉÍÓÚ0-9 ]+\z/) && correct_answer.match?(/\A[.\- ]+\z/))
        else
          return false
        end

      when 'To_complete'
        return (key_word.match?(/[a-zA-ZñÑáéíóúÁÉÍÓÚ0-9]+/) and key_word_morse.match?(/^[.-]+$/))

      when 'MouseTranslation', 'FallingObject'
        return correct_answer.match?(/^[.-]+$/)

      else
        return false
      end
    end
  end
end
