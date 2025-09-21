# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Fabricate.times(10, :user)

puts "Running seeds for environment: #{Rails.env}"

users = [
  { email: "john@example.com", name: "John" },
  { email: "jane@example.com", name: "Jane" },
  { email: "bob@example.com",  name: "Bob"  }
]

users.each do |attrs|
  user = User.find_or_initialize_by(email: attrs[:email])
  user.name = attrs[:name]
  user.password = "Password@123"
  user.password_confirmation = "Password@123"
  user.save!
  puts "✓ Seeded #{user.email}"
end
