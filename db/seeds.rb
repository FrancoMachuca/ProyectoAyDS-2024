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

levels = [
  {name: 'Level 1'},
  {name: 'Level 2'},
  {name: 'Level 3'}
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

levels.each do |l|
    Level.create(l)
end
