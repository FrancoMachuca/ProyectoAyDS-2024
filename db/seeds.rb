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

users = [
  {name: 'Franco Machuca', mail: 'e@example.com', password: 'bokita'},
  {name: 'Valentino Natali', mail: 'R@example.com', password: '123'},
  {name: 'Ignacio Cerutti Norris', mail: 'L@example.com', password: '456'}
]

levels = [
  {name: 'Level 1', playable: Lesson.create!()},
  {name: 'Level 2', playable: Lesson.create!()},
  {name: 'Level 3', playable: Lesson.create!()},
  {name: 'Level 4', playable: Lesson.create!()},
  {name: 'Level 5', playable: Lesson.create!()}
]

users.each do |u|
  user = User.create(u)
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
    description: 'Traduce "... --- .-.." al Español',
    level_name: 'Level 1',
    questionable: Translation.create!(),
    answers: [
      {answer: 'sol', correct: true}
    ]
  },
  {
    description: '¿Cómo se representa la palabra "SOL" en código morse?',
    level_name: 'Level 1',
    questionable: Multiple_choice.create!(),
    answers: [
      {answer: '... --- .-.', correct: false},
      {answer: '... --- ..', correct: false},
      {answer: '... --- .-..', correct: true},
      {answer: '... --- .--', correct: false}
    ]
  },
  {
    description: '¿Cómo se representa la palabra "CASA" en código morse?',
    level_name: 'Level 1',
    questionable: Multiple_choice.create!(),
    answers: [
      {answer: ' -.-. .- ... ..-', correct: false},
      {answer: ' -.-. .- ... .-', correct: true},
      {answer: '-.-. .- ... .', correct: false},
      {answer: ' -.-. .- ..- .-', correct: false}
    ]
  },
  {
    description: '¿Cómo se representa la palabra "SOS" en código morse?',
    level_name: 'Level 1',
    questionable: Multiple_choice.create!(),
    answers: [
      {answer: '.-.-.- ... .-.-.-', correct: false},
      {answer: '... --- ...', correct: true},
      {answer: '... --- ..', correct: false},
      {answer: '... --- .-', correct: false}
    ]
  },
  {
    description: 'Completa la siguiente palabra:',
    level_name: 'Level 2',
    questionable: To_complete.create!(keyword: "Sol", toCompleteMorse: "... ____ .-.."),
    answers: [
      {answer: "... --- .-..", correct: true}
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
