User.destroy_all

taylor = User.create!(email: "fu@bar.com", password: "test")
dane = User.create!(email: "bu@far.com", password: "nico")

taylor.followers << dane
