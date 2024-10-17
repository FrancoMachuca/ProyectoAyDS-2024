require './models/question'
require './models/answer'
require './models/level'
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

  def createNewQuestion(question_type: String,options: , translation_type: String, key_word: String, key_word_morse: String, correct_answer: String, question_description: String, level: Level)
    case question_type
    when "Multiple_choice"
      @question = Question.create!(description: question_description, level: level, questionable: Multiple_choice.create!())
      options.each do |op|
        Answer.create!(answer: op[:text], correct: op[:correct], question: @question)
      end
    when "Translation"
      if translation_type == "morse_translation"
        unless question_description.match?(/\b[.\-]+\b/)
          halt 400, "La descripción debe contener al menos una palabra en formato Morse si se seleccionó 'Traducción de Morse a Español'"
        end

        unless correct_answer.match?(/\A[a-zA-ZñÑáéíóúÁÉÍÓÚ ]+\z/)
          halt 400, "La respuesta debe estar en español"
        end

      elsif translation_type == "spanish_translation"
        unless question_description.match?(/\b[a-zA-ZñÑáéíóúÁÉÍÓÚ]+\b/)
          halt 400, "La descripción debe contener al menos una palabra en español si se seleccionó 'Traducción de Español a Morse'"
        end

        unless correct_answer.match?(/\A[.\- ]+\z/)
          halt 400, "La respuesta debe estar en formato Morse (solo . y -)"
        end
      end

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
    return "Pregunta creada exitosamente"
  end
end
