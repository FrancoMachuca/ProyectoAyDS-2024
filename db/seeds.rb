require_relative '../models/user'
require_relative '../models/level'
require_relative '../models/lesson'
require_relative '../models/exam'
require_relative '../models/question'
users = [
  {name: 'John', mail: 'e@example.com', password: 'bokita', totalScore: 0},
  {name: 'Roberto', mail: 'R@example.com', password: '123', totalScore: 0},
  {name: 'Laura', mail: 'L@example.com', password: '456', totalScore: 0}
]

questions = [
  {description: 'a'},
  {description: 'b'},
  {description: 'c'}
]

levels = [
  {},
  {},
  {}
]

lessons = [
  {},
  {}
]

exams = [
  {minScore: 70},
  {minScore: 60},
  {minScore: 65}
]

users.each do |u|
    puts u
    user = (User.create(u))
    if user.save
      puts "tuki"
    else
      puts "no tuki"
    end
  end
questions.each do |q|
  Question.create(q)
end

levels.each do |l|
    Level.create(l)
end


lessons.each do |ls|
  Lesson.create(ls)
end

exams.each do |e|
  Exam.create(e)
end