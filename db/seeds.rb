require_relative '../models/user'
require_relative '../models/level'
require_relative '../models/lesson'
require_relative '../models/exam'
require_relative '../models/question'
users = [
  {name: 'Franco Machuca', mail: 'e@example.com', password: 'bokita', totalScore: 300},
  {name: 'Valentino Natali', mail: 'R@example.com', password: '123', totalScore: 100},
  {name: 'Ignacio Cerutti Norris', mail: 'L@example.com', password: '456', totalScore: 250}
]

levels = [
  {name: 'Level 1'},
  {name: 'Level 2'},
  {name: 'Level 3'},
  {name: 'Level 4'},
  {name: 'Level 5'}
]



users.each do |u|
    puts u
    user = (User.create(u))
    user.save
  end

  levels.each do |l|
    level = Level.create(l)
    if level.save
      puts "Nivel #{level.name} creado correctamente."
    else
      puts "Error al crear el nivel #{l[:name]}."
    end
  end
