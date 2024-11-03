# frozen_string_literal: true

# Clase encargada de validar la información ingresada por el usuario para la creación de preguntas y niveles.
class QuestionsValidator
  def validate_params(options:, correct_answer: String, question_description: String,
                      level: Level,
                      question_type: String, translation_type:
                      String, key_word: String, key_word_morse: String)
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

  def validate_multiple_choice(options:)
    options.size <= 4 &&
      options.all? { |elem| !elem[:text].empty? } &&
      options.one? { |elem| elem[:correct] }
  end

  def validate_to_complete(key_word: String, key_word_morse: String)
    key_word.match?(/[a-zA-ZñÑáéíóúÁÉÍÓÚ0-9]+/) &&
      key_word_morse.match?(/^[.-]+$/)
  end

  def validate_morse_answer(correct_answer: String)
    correct_answer.match?(/^[.-]+$/)
  end

  def valid_level?(level)
    !level.nil? && Level.exists?(level.id)
  end
end
