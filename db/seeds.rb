users = [
  {name: 'John', mail: 'e@example.com', password: 'bokita', totalScore: 0},
  {name: 'Roberto', mail: 'R@example.com', password: '123', totalScore: 0},
  {name: 'Laura', mail: 'L@example.com', password: '456', totalScore: 0}
]

users.each do |u|
    User.create(u)
  end