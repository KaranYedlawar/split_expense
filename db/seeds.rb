# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Fabricate.times(10, :user)

puts "Running seeds for environment: #{Rails.env}"

[
  { email: "john@example.com", name: "John" },
  { email: "jane@example.com", name: "Jane" },
  { email: "bob@example.com",  name: "Bob"  }
].each do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |user|
    user.name = attrs[:name]
    user.password = "Password@123"
    user.password_confirmation = "Password@123"
  end
end
