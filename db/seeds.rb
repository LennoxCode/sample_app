User.create!(name: "Leonard Valentin",
             email: "leonard.valentin1999@gmail.com",
             password: "kingshit",
             password_confirmation: "kingshit",
             admin: true)

99.times do |n|
  name = Faker::Name.name
  email = "test#{n+1}@example.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end
