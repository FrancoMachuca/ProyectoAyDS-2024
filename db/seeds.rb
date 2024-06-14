require_relative '../models/user'
require_relative '../models/level'
require_relative '../models/lesson'
require_relative '../models/exam'
require_relative '../models/question'
require_relative '../models/multiple_choice'
require_relative '../models/translation'
require_relative '../models/answer'

users = [
  {name: 'Franco Machuca', mail: 'e@example.com', password: 'bokita'},
  {name: 'Valentino Natali', mail: 'R@example.com', password: '123'},
  {name: 'Ignacio Cerutti Norris', mail: 'L@example.com', password: '456'}
]

lessons = [
  {help: 'Ayuda para Level 1', name: 'Level 1'},
  {help: 'Ayuda para Level 2', name: 'Level 2'},
  {help: 'Ayuda para Level 3', name: 'Level 3'},
  {help: 'Ayuda para Level 4', name: 'Level 4'},
  {help: 'Ayuda para Level 5', name: 'Level 5'}
]

users.each do |u|
  user = User.create(u)
  user.save
end

lessons.each do |l|
  lesson = Lesson.create!(help: l[:help])
  level = Level.create!(name: l[:name], playable: lesson)
  if level.save and lesson.save
    puts "El '#{level.name}' ha sido creado correctamente."
  else
    puts "Error al crear '#{level.name}'"
  end
end

# Creación de preguntas
questions = [
{description: 'Traduce "... --- .-.." al Español', level_id: Level.find_by(name: 'Level 1').id,
questionable: Translation.create!(), playable_id: Level.find_by(name: 'Level 1').playable_id, playable_type: Level.find_by(name: 'Level 1').playable_type},
{description: '¿Cómo se representa la palabra "SOL" en código morse?', level_id: Level.find_by(name: 'Level 1').id,
questionable: Multiple_choice.create!(), playable_id: Level.find_by(name: 'Level 1').playable_id, playable_type: Level.find_by(name: 'Level 1').playable_type},
{description: '¿Cómo se representa la palabra "CASA" en código morse?', level_id: Level.find_by(name: 'Level 1').id,
questionable: Multiple_choice.create!(), playable_id: Level.find_by(name: 'Level 1').playable_id, playable_type: Level.find_by(name: 'Level 1').playable_type}
]

#questionsAux = [{description: '¿Cómo se representa la palabra "FUEGO" en código morse?', level_id: Level.find_by(name: 'Level 1').id},
#{description: '¿Cómo se representa la palabra "ÁRBOL" en código morse?', level_id: Level.find_by(name: 'Level 1').id},
#{description: '¿Cómo se representa la palabra "PERRO" en código morse?', level_id: Level.find_by(name: 'Level 2').id},
#{description: '¿Cómo se representa la palabra "SOS" en código morse?', level_id: Level.find_by(name: 'Level 2').id},
#{description: '¿Cómo se representa la palabra "GATO" en código morse?', level_id: Level.find_by(name: 'Level 2').id},
#{description: '¿Cómo se representa la palabra "HOLA" en código morse?', level_id: Level.find_by(name: 'Level 2').id}]


questions.each do |q|
  question = Question.create(q)

  if question.save
    puts "Pregunta '#{question.description}' creada correctamente."
  else
    puts "Error al crear la pregunta '#{q[:description]}'."
  end
end

answers = [
  {answer: '... --- .-..', correct: true, question_id: Question.second.id},
  {answer: ' ... --- .-.', correct: false, question_id: Question.second.id},
  {answer: '... --- ..', correct: false, question_id: Question.second.id},
  {answer: '... --- ..', correct: false, question_id: Question.second.id},
  {answer: ' -.-. .- ... ..-', correct: false, question_id: Question.third.id},
  {answer: ' -.-. .- ... .-', correct: true, question_id: Question.third.id},
  {answer: '-.-. .- ... .', correct: false, question_id: Question.third.id},
  {answer: ' -.-. .- ..- .-', correct: false, question_id: Question.third.id},
  {answer: 'Sol', correct: false, question_id: Question.first.id}
]

answers.each do |a|
  answer = Answer.create!(a)

  if answer.save
    puts "Respuesta '#{answer.answer}' creada correctamente"
  else
    puts "Error al crear la respuesta '#{answer.answer}'"
  end
end
