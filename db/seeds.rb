# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


if Rails.env.production?
  # Fabricate 10 random users
  Fabricate.times(10, :user)

  # Seed specific users
  users_to_seed = [
    { email: "john@example.com", name: "John" },
    { email: "anbu@example.com", name: "Anbu" },
    { email: "barath@example.com", name: "Barath" }
  ]

  users_to_seed.each do |attrs|
    user = User.find_or_initialize_by(email: attrs[:email])
    user.name = attrs[:name]
    user.password ||= "password"
    user.password_confirmation ||= "password"
    user.save!
  end
end


