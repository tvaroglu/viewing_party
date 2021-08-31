User.destroy_all

tom = User.create!(email: 'tom@myspace.com', password: 'lol')
taylor = User.create!(email: 'foo@bar.com', password: 'test')
dane = User.create!(email: 'boo@far.com', password: 'nico')
admin = User.create!(email: 'admin@example.com', password: 'guest')

taylor.followers << dane
dane.followers << taylor
