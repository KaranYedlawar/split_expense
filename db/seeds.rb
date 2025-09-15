# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Fabricate.times(10, :user)
# db/seeds.rb

puts "Running seeds for environment: #{Rails.env}"

if Rails.env.production?
  users = [
    { email: "john@example.com",  name: "John" },
    { email: "anbu@example.com",  name: "Anbu" },
    { email: "barath@example.com", name: "Barath" }
  ]

  users.each do |attrs|
    user = User.find_or_initialize_by(email: attrs[:email])
    user.update!(
      name:                  attrs[:name],
      password:              "password",
      password_confirmation: "password"
    )
  end

  puts "Ensured test users exist: #{users.map { |u| u[:email] }.join(', ')}"
else
  puts "Skipping user seeds: not running in production environment."
end
