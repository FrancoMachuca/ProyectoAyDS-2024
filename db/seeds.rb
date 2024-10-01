require_relative '../models/user'
require_relative '../models/level'
require_relative '../models/lesson'
require_relative '../models/exam'
require_relative '../models/question'
require_relative '../models/multiple_choice'
require_relative '../models/translation'
require_relative '../models/answer'
require_relative '../models/user_level'
require_relative '../models/to_complete'
require_relative '../models/mouse_translation'
require_relative '../models/image'
require_relative '../models/default_image'
require_relative '../models/falling_object'
require_relative '../models/tutorial'

image = DefaultImage.new
File.open('public\uploads\genericAvatar.png') do |f|
  image.image = f
end
image.caption = 'Profile Pic'


users = [
  {name: 'Franco Machuca', mail: 'e@example.com', password: 'bokita'},
  {name: 'Valentino Natali', mail: 'R@example.com', password: '123'},
  {name: 'Ignacio Cerutti Norris', mail: 'L@example.com', password: '456'}
]

levels = [
  {name: 'Tutorial', playable: Tutorial.create!()},
  {name: 'Letras I', playable: Lesson.create!()},
  {name: 'Letras II', playable: Lesson.create!()},
  {name: 'Palabras I', playable: Lesson.create!()},
  {name: 'Palabras II', playable: Lesson.create!()},
  {name: 'Palabras III', playable: Lesson.create!()},
  {name: 'Examen I', playable: Exam.create!(minScore: 500)},
  {name: 'Nuevo juego', playable: Lesson.create!()}
]

users.each do |u|
  user = User.create(u)
  user.image = image
  user.save
end

levels.each do |l|
  level = Level.create!(l)
  if level.save
    puts "El '#{level.name}' ha sido creado correctamente."
  else
    puts "Error al crear '#{level.name}'"
  end
end

users = User.all
level = Level.first

users.each do |u|
  UserLevel.create(user: u, level: level, userLevelScore: 0)
end

# Creación de preguntas
questions_data = [
  {
    descripcion: 'Test',
    level_name: 'Tutorial',
    questionable: Multiple_choice.create!(),
    answers: [
      {answer: 'Correcta', correct: true},
      {answer: 'falsa', correct: false},
      {answer: 'falsa', correct: false},
      {answer: 'falsa', correct: false}
    ]
  },
  {
    descripcion: 'Test',
    level_name: 'Tutorial',
    questionable: MouseTranslation.create!(),
    answers: [
      {answer: '.-', correct: true}
    ]
  },
  {
    description: 'Completa la siguiente letra en código morse:',
    level_name: 'Tutorial',
    questionable: To_complete.create!(keyword: "C", toCompleteMorse: "-__."),
    answers: [
      {answer: "-.-.", correct: true}
    ]
  },
  {
    description: 'Traduce ".---" al Español',
    level_name: 'Tutorial',
    questionable: Translation.create!(),
    answers: [
      {answer: 'j', correct: true}
    ]
  },
  {
    description: 'Traduce "M" a código morse',
    level_name: 'Tutorial',
    questionable: FallingObject.create!(),
    answers: [
      {answer: "--", correct: true}
    ]
  },
  # Nivel 1: Aprender letras (Fácil)
  {
    description: 'Traduce ".-" al Español',
    level_name: 'Letras I',
    questionable: Translation.create!(),
    answers: [
      {answer: 'a', correct: true}
    ]
  },
  {
    description: '¿Cómo se representa la letra "B" en código morse?',
    level_name: 'Letras I',
    questionable: Multiple_choice.create!(),
    answers: [
      {answer: '-...', correct: true},
      {answer: '...-', correct: false},
      {answer: '-.-.', correct: false},
      {answer: '.--.', correct: false}
    ]
  },
  {
    description: 'Traduce "-.-." al Español',
    level_name: 'Letras I',
    questionable: Translation.create!(),
    answers: [
      {answer: 'c', correct: true}
    ]
  },
  {
    description: 'Traduce "d" a código morse',
    level_name: 'Letras I',
    questionable: MouseTranslation.create!(),
    answers: [
      {answer: '-..', correct: true}
    ]
  },
  # Nivel 2: Aprender letras (Medio)
  {
    description: 'Completa la siguiente letra en código morse:',
    level_name: 'Letras II',
    questionable: To_complete.create!(keyword: "A", toCompleteMorse: "._"),
    answers: [
      {answer: ".-", correct: true}
    ]
  },
  {
    description: 'Completa la siguiente letra en código morse:',
    level_name: 'Letras II',
    questionable: To_complete.create!(keyword: "P", toCompleteMorse: ".__."),
    answers: [
      {answer: ".--.", correct: true}
    ]
  },
  {
    description: '¿Cómo se representa la letra "F" en código morse?',
    level_name: 'Letras II',
    questionable: Multiple_choice.create!(),
    answers: [
      {answer: '..-.', correct: true},
      {answer: '...-', correct: false},
      {answer: '.-..', correct: false},
      {answer: '-..-', correct: false}
    ]
  },
  {
    description: 'Traduce "h" a código morse',
    level_name: 'Letras II',
    questionable: MouseTranslation.create!(),
    answers: [
      {answer: '....', correct: true}
    ]
  },
  # Nivel 3: Aprender palabras (Fácil)
  {
    description: '¿Cómo se representa la palabra "GATO" en código morse?',
    level_name: 'Palabras I',
    questionable: Multiple_choice.create!(),
    answers: [
      {answer: '--. .- - ---', correct: true},
      {answer: '--. .- .. ---', correct: false},
      {answer: '--. .- - ..', correct: false},
      {answer: '--. .- .- -', correct: false}
    ]
  },
  {
    description: 'Traduce "--. .- - ---" al Español',
    level_name: 'Palabras I',
    questionable: Translation.create!(),
    answers: [
      {answer: 'gato', correct: true}
    ]
  },
  {
    description: '¿Cómo se representa la palabra "PERRO" en código morse?',
    level_name: 'Palabras I',
    questionable: Multiple_choice.create!(),
    answers: [
      {answer: '.--. . .-. .-. ---', correct: true},
      {answer: '.--. . .-. .-. .-', correct: false},
      {answer: '.--. . .-. .- .-', correct: false},
      {answer: '.--. . .-. .- ---', correct: false}
    ]
  },
  {
    description: 'Traduce "sol" a código morse',
    level_name: 'Palabras I',
    questionable: MouseTranslation.create!(),
    answers: [
      {answer: '... --- .-..', correct: true}
    ]
  },
  # Nivel 4: Aprender palabras (Medio)
  {
    description: 'Completa la siguiente palabra en código morse:',
    level_name: 'Palabras II',
    questionable: To_complete.create!(keyword: "CASA", toCompleteMorse: "-.-. .- ___ .-"),
    answers: [
      {answer: "-.-. .- ... .-", correct: true}
    ]
  },
  {
    description: 'Completa la siguiente palabra en código morse:',
    level_name: 'Palabras II',
    questionable: To_complete.create!(keyword: "SOL", toCompleteMorse: "... ___ .-.."),
    answers: [
      {answer: "... --- .-..", correct: true}
    ]
  },
  {
    description: '¿Cómo se representa la palabra "LUNA" en código morse?',
    level_name: 'Palabras II',
    questionable: Multiple_choice.create!(),
    answers: [
      {answer: '.-.. ..- -. .-', correct: true},
      {answer: '.-.. ..- -. .', correct: false},
      {answer: '.-.. ..- .. .-', correct: false},
      {answer: '.-.. ..- -. ..', correct: false}
    ]
  },
  {
    description: 'Traduce "casa" a código morse',
    level_name: 'Palabras II',
    questionable: MouseTranslation.create!(),
    answers: [
      {answer: '-.-. .- ... .-', correct: true}
    ]
  },
  # Nivel 5: Aprender palabras (Difícil)
  {
    description: '¿Cómo se representa la palabra "PROGRAMAR" en código morse?',
    level_name: 'Palabras III',
    questionable: Multiple_choice.create!(),
    answers: [
      {answer: '.--. .-. --- --. .-. .- -- .- .-.', correct: true},
      {answer: '.--. .-. --- --. .-. .- -- .-', correct: false},
      {answer: '.--. .-. --- --. .-. .- -- .-..', correct: false},
      {answer: '.--. .-. --- --. .-. .- -- .-.-', correct: false}
    ]
  },
  {
    description: 'Traduce ".--. .-. --- --. .-. .- -- .- .-." al Español',
    level_name: 'Palabras III',
    questionable: Translation.create!(),
    answers: [
      {answer: 'programar', correct: true}
    ]
  },
  {
    description: 'Completa la siguiente palabra en código morse:',
    level_name: 'Palabras III',
    questionable: To_complete.create!(keyword: "CODIGO", toCompleteMorse: "____ --- -.. __ --. ---"),
    answers: [
      {answer: "-.-. --- -.. .. --. ---", correct: true}
    ]
  },
  {
    description: 'Traduce "código" a código morse',
    level_name: 'Palabras III',
    questionable: MouseTranslation.create!(),
    answers: [
      {answer: '-.-. --- -.. .. --. ---', correct: true}
    ]
  },
  {
    description: '¿Cómo se representa la letra "M" en código morse?',
    level_name: 'Examen I',
    questionable: Multiple_choice.create!(),
    answers: [
      {answer: '--', correct: true},
      {answer: '-.', correct: false},
      {answer: '.-', correct: false},
      {answer: '..', correct: false}
    ]
  },
  {
    description: 'Traduce ".--" al Español',
    level_name: 'Examen I',
    questionable: Translation.create!(),
    answers: [
      {answer: 'w', correct: true}
    ]
  },
  {
    description: 'Traduce "..-." al Español',
    level_name: 'Examen I',
    questionable: Translation.create!(),
    answers: [
      {answer: 'f', correct: true}
    ]
  },
  {
    description: '¿Cómo se representa la palabra "AMIGO" en código morse?',
    level_name: 'Examen I',
    questionable: Multiple_choice.create!(),
    answers: [
      {answer: '.- -- .. --. ---', correct: true},
      {answer: '.- -- .. - ---', correct: false},
      {answer: '.- -- .. -- .', correct: false},
      {answer: '.- -- .. -- ..', correct: false}
    ]
  },
  {
    description: 'Traduce "paz" a código morse',
    level_name: 'Examen I',
    questionable: MouseTranslation.create!(),
    answers: [
      {answer: '.--. .- --..', correct: true}
    ]
  },
  {
    description: 'Traduce "-. --- .-. - ." al Español',
    level_name: 'Examen I',
    questionable: Translation.create!(),
    answers: [
      {answer: 'norte', correct: true}
    ]
  },
  {
    description: '¿Cómo se representa la palabra "AGUA" en código morse?',
    level_name: 'Examen I',
    questionable: Multiple_choice.create!(),
    answers: [
      {answer: '.- --. ..- .-', correct: true},
      {answer: '.- --. ..- .', correct: false},
      {answer: '.- --. ..- --', correct: false},
      {answer: '.- --. ..- ..', correct: false}
    ]
  },
  {
    description: 'Completa la siguiente palabra en código morse:',
    level_name: 'Examen I',
    questionable: To_complete.create!(keyword: "BUSCAR", toCompleteMorse: "-__. ._- ... ____ .- .-."),
    answers: [
      {answer: "-... ..- ... -.-. .- .-.", correct: true}
    ]
  },
  {
    description: 'Traduce "amigo" a código morse',
    level_name: 'Examen I',
    questionable: MouseTranslation.create!(),
    answers: [
      {answer: '.- -- .. --. ---', correct: true}
    ]
  },
  {
    description: 'Completa la siguiente palabra en código morse:',
    level_name: 'Examen I',
    questionable: To_complete.create!(keyword: "SILLA", toCompleteMorse: "... __ .-.. .-.. .-"),
    answers: [
      {answer: "... .. .-.. .-.. .-", correct: true}
    ]
  },
  {
    description: 'Traduce "A" a código morse',
    level_name: 'Nuevo juego',
    questionable: FallingObject.create!(),
    answers: [
      {answer: ".-", correct: true}
    ]
  },
  {
    description: 'Traduce "S" a código morse',
    level_name: 'Nuevo juego',
    questionable: FallingObject.create!(),
    answers: [
      {answer: "...", correct: true}
    ]
  },
  {
    description: 'Traduce "B" a código morse',
    level_name: 'Nuevo juego',
    questionable: FallingObject.create!(),
    answers: [
      {answer: "-...", correct: true}
    ]
  },
  {
    description: 'Traduce "P" a código morse',
    level_name: 'Nuevo juego',
    questionable: FallingObject.create!(),
    answers: [
      {answer: ".--.", correct: true}
    ]
  }
]

questions_data.each do |q_data|
  level = Level.find_by(name: q_data[:level_name])
  question = Question.create(description: q_data[:description], level: level, questionable: q_data[:questionable])

  if question.save
    q_data[:answers].each do |a_data|
      answer = Answer.create(answer: a_data[:answer], correct: a_data[:correct], question: question)
      if answer.save
        puts "Respuesta '#{answer.answer}' creada correctamente para la pregunta '#{question.description}'."
      else
        puts "Error al crear la respuesta '#{a_data[:answer]}' para la pregunta '#{question.description}'."
      end
    end
    puts "Pregunta '#{question.description}' creada correctamente."
  else
    puts "Error al crear la pregunta '#{q_data[:description]}'."
  end
end
