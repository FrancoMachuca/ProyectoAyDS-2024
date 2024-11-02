# frozen_string_literal: true

require './models/question'
require './models/answer'
require './models/level'
require './models/falling_object'

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ParameterLists

# Esta clase se encarga de administrar las preguntas del juego y sus respuestas.
class QuestionsManager
  # Devuelve la vista correspondiente a una pregunta según su tipo.
  def show(question: Question)
    view_lookup = {
      'MultipleChoice' => :multiple_choice,
      'Translation' => :translation,
      'ToComplete' => :to_complete,
      'MouseTranslation' => :mouse_translation,
      'FallingObject' => :falling_object
    }
    view_lookup[question.questionable_type]
  end

  # Método que analiza una respuesta a una pregunta y devuelve un booleano indicando si es correcta o no.
  def correct_answer?(answer: Answer, question: Question)
    if question.questionable_type == 'MultipleChoice'
      answer.correct
    elsif %w[Translation ToComplete MouseTranslation FallingObject].include?(question.questionable_type)
      user_guess = answer.answer.gsub(/\s+/, '').downcase
      correct_phrase = question.answers.find_by(correct: true).answer.gsub(/\s+/, '').downcase
      user_guess == correct_phrase
    else
      puts 'No se reconoce el tipo'
    end
  end

  # Dada una pregunta, devuelve la siguiente a ella (que pertenece al mismo nivel).
  def next_question(question: Question)
    question_family = question.level.questions
    actual_question_index = question_family.find_index(question)
    question_family[actual_question_index + 1]
  end

  def build_player_answer(answer: String, question: Question)
    Answer.new(answer: answer, correct: false, question: question)
  end

  def create_new_question(options:, question_type: String, translation_type: String, key_word: String, key_word_morse: String, correct_answer: String,
                          question_description: String, level: Level)
    return false unless validate_params(
      question_type: question_type, options: options, translation_type: translation_type,
      key_word: key_word, key_word_morse: key_word_morse, correct_answer: correct_answer,
      question_description: question_description, level: level
    )

    question_class_mapping = {
      'MultipleChoice' => MultipleChoice,
      'Translation' => Translation,
      'ToComplete' => ToComplete,
      'MouseTranslation' => MouseTranslation,
      'FallingObject' => FallingObject
    }

    question_class = question_class_mapping[question_type]
    return false unless question_class

    @question = create_question_record(question_class,
                                       question_type: question_type, question_description: question_description,
                                       level: level, key_word: key_word, key_word_morse: key_word_morse)
    create_answers(options: options, question: @question, question_type: question_type, correct_answer: correct_answer )
    true
  end

  def validate_params(options:, correct_answer: String, question_description: String, level: Level,
                      question_type: String, translation_type: String, key_word: String, key_word_morse: String)
    return true unless valid_level?(level)

    # Asocio un método validator a un tipo de pregunta.
    validators = {
      'MultipleChoice' => method(:validate_multiple_choice),
      'Translation' => method(:validate_translation),
      'ToComplete' => method(:validate_to_complete),
      'MouseTranslation' => method(:validate_morse_answer),
      'FallingObject' => method(:validate_morse_answer)
    }
    # Asocio parámetros específicos para cada validator según el tipo de pregunta.
    required_params = {
      'MultipleChoice' => { options: options },
      'Translation' => { translation_type: translation_type, correct_answer: correct_answer,
                         question_description: question_description },
      'ToComplete' => { key_word: key_word, key_word_morse: key_word_morse },
      'MouseTranslation' => { correct_answer: correct_answer },
      'FallingObject' => { correct_answer: correct_answer }
    }
    # Elijo un validator según el tipo de pregunta recibido.
    validator = validators[question_type]
    return false unless validator

    # Invoco al validator seleccionado con su respectiva lista de parámetros.
    validator.call(**required_params[question_type])
  end

  private

  def create_question_record(question_class, question_type: String, question_description: String, level: Level,
                             key_word: String, key_word_morse: String)
    questionable_instance = if question_type == 'ToComplete'
                              question_class.create!(keyword: key_word, toCompleteMorse: key_word_morse)
                            else
                              question_class.create!
                            end

    Question.create!(description: question_description, level: level, questionable: questionable_instance)
  end

  def create_answers(options:, question: Question, question_type: String, correct_answer: String)
    case question_type
    when 'MultipleChoice'
      options.each do |op|
        Answer.create!(answer: op[:text], correct: op[:correct], question: question)
      end
    else
      Answer.create!(answer: correct_answer, correct: true, question: question)
    end
  end

  def valid_level?(level)
    !level.nil? && Level.exists?(level.id)
  end

  def validate_multiple_choice(options:)
    options.size <= 4 &&
      options.all? { |elem| !elem[:text].empty? } &&
      options.one? { |elem| elem[:correct] }
  end

  def validate_translation(translation_type: String, correct_answer: String, question_description: String)
    case translation_type
    when 'morse_translation'
      question_description.match?(/.*[.\-]+.*$/) &&
        correct_answer.match?(/\A[a-zA-ZñÑáéíóúÁÉÍÓÚ0-9 ]+\z/)
    when 'spanish_translation'
      question_description.match?(/\A[a-zA-ZñÑáéíóúÁÉÍÓÚ0-9 ]+\z/) &&
        correct_answer.match?(/\A[.\- ]+\z/)
    else
      false
    end
  end

  def validate_to_complete(key_word: String, key_word_morse: String)
    key_word.match?(/[a-zA-ZñÑáéíóúÁÉÍÓÚ0-9]+/) &&
      key_word_morse.match?(/^[.-]+$/)
  end

  def validate_morse_answer(correct_answer: String)
    correct_answer.match?(/^[.-]+$/)
  end
end

# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/ParameterLists
