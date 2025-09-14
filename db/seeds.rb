# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Fabricate.times(10, :user)

[
  { email: "john@example.com", name: "John" },
  { email: "anbu@example.com", name: "Anbu" },
  { email: "barath@example.com", name: "Barath" }
].each do |user_attrs|
  User.find_or_create_by!(email: user_attrs[:email]) do |user|
    user.name = user_attrs[:name]
    user.password = "password"
    user.password_confirmation = "password"
  end
end

