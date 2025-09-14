FactoryBot.define do
  factory :expense_user do
    association :expense
    association :user
    share_amount { Faker::Commerce.price(range: 1..50) }
  end
end
