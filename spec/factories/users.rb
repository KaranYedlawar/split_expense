FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password" }
    # confirm_password { "password" }
    mobile_number { Faker::Number.unique.number(digits: 10).to_s }
  end
end
