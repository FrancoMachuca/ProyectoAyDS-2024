require_relative '../models/user'
require_relative '../models/level'
require_relative '../models/lesson'
require_relative '../models/exam'
require_relative '../models/question'
require_relative '../models/multiple_choice'
require_relative '../models/answer'

users = [
  {name: 'Franco Machuca', mail: 'e@example.com', password: 'bokita'},
  {name: 'Valentino Natali', mail: 'R@example.com', password: '123'},
  {name: 'Ignacio Cerutti Norris', mail: 'L@example.com', password: '456'}
]

lessons = [
  {help: 'Level 1'},
  {name: 'Level 2'},
  {name: 'Level 3'},
  {name: 'Level 4'},
  {name: 'Level 5'}
]


levels = [
  {name: 'Level 1'},
  {name: 'Level 2'},
  {name: 'Level 3'},
  {name: 'Level 4'},
  {name: 'Level 5'}
]

users.each do |u|
  user = User.create(u)
  user.save
end

lessons.each do |l|
  levels.each do |r|
    level = Level.create! playable: Lesson.new(l), name: r.name
    if level.save
      puts "Nivel #{level.name} creado correctamente."
    else
      puts "Error al crear el nivel #{l[:name]}."
  end
end

# Creación de preguntas
questions = [
{description: '¿Cómo se representa la palabra "SOL" en código morse?', level_id: Level.find_by(name: 'Level 1').id},
{description: '¿Cómo se representa la palabra "CASA" en código morse?', level_id: Level.find_by(name: 'Level 1').id},
{description: '¿Cómo se representa la palabra "A" en código morse?', level_id: Level.find_by(name: 'Level 1').id}
]

questionsAux = [{description: '¿Cómo se representa la palabra "FUEGO" en código morse?', level_id: Level.find_by(name: 'Level 1').id},
{description: '¿Cómo se representa la palabra "ÁRBOL" en código morse?', level_id: Level.find_by(name: 'Level 1').id},
{description: '¿Cómo se representa la palabra "PERRO" en código morse?', level_id: Level.find_by(name: 'Level 2').id},
{description: '¿Cómo se representa la palabra "SOS" en código morse?', level_id: Level.find_by(name: 'Level 2').id},
{description: '¿Cómo se representa la palabra "GATO" en código morse?', level_id: Level.find_by(name: 'Level 2').id},
{description: '¿Cómo se representa la palabra "HOLA" en código morse?', level_id: Level.find_by(name: 'Level 2').id}]

#answers = [
#  {answer: '... --- .-..', correct: true, multiple_choice_id: Question.first.id},
#  {answer: ' ... --- .-.', correct: false, multiple_choice_id: Question.first.id},
#  {answer: '... --- ..', correct: false, multiple_choice_id: Question.first.id},
#  {answer: '... --- ..', correct: false, multiple_choice_id: Question.first.id},
#  {answer: ' -.-. .- ... ..-', correct: false, multiple_choice_id: Question.second.id},
#  {answer: ' -.-. .- ... .-', correct: true, multiple_choice_id: Question.second.id},
#  {answer: '-.-. .- ... .', correct: false, multiple_choice_id: Question.second.id},
#  {answer: ' -.-. .- ..- .-', correct: false, multiple_choice_id: Question.second.id}
#]

questions.each do |q|
  question = Question.create(q)

  if question.save
    puts "Pregunta '#{question.description}' creada correctamente."
  else
    puts "Error al crear la pregunta '#{q[:description]}'."
  end
  ans = Answer.create(question_id: question.id, answer: '... --- .-..', correct: true)
  ans = Answer.create(question_id: question.id, answer: ' ... --- .-.', correct: false)
  ans = Answer.create(question_id: question.id, answer: '... --- ..', correct: false)
  ans = Answer.create(question_id: question.id, answer: '... --- ..', correct: false)
end


#multiple_choices = [
#  {question_id: Question.find_by(description: '¿Cómo se representa la palabra "SOL" en código morse?').id},
#  {question_id: Question.find_by(description: '¿Cómo se representa la palabra "CASA" en código morse?').id}
#]

#multiple_choices.each do |mc|
#  multiple_choice = Multiple_choice.create(mc)
#  if multiple_choice.save
#    puts "Pregunta de opción múltiple creada correctamente."
#  else
#    puts "Error al crear la pregunta de opción múltiple."
#  end
#end

# Asumiendo que las preguntas creadas arriba son las primeras preguntas de la base de datos


#multiple_choice_answers.each do |mca|
#  answer = MultipleChoiceAnswer.create(mca)
#  if answer.save
#    puts "Respuesta '#{answer.answer}' creada correctamente."
#  else
#    puts "Error al crear la respuesta '#{mca[:answer]}'."
#  end
#end
