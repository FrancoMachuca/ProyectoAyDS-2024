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
    end
  end

  # Método que analiza una respuesta a una pregunta y devuelve un booleano indicando si es correcta o no.
  def correctAnswer?(answer: Answer, question: Question)
    case question.questionable_type
      when 'Multiple_choice'
        return answer.correct
      when 'Translation'
        user_translation = answer.answer
        correct_translation = question.answer.answer.strip.downcase
        result = user_translation == correct_translation
        return result
      else
        puts "No se reconoce tipo"
    end
  end

  # Dada una pregunta (question), devuelve la siguiente a ella (que pertenece al mismo nivel). Devuelve nil si question es la última de su nivel.
  def nextQuestion(question: Question)
    question_family = question.level.questions
    actual_question_index = question_family.find_index(question)
    next_question = question_family[actual_question_index + 1]
    return next_question
  end

  def buildUserAnswer(answer: String, question: Question)
    return Answer.new(answer: answer, correct: false, question: question)
  end


end
