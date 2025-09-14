FactoryBot.define do
  factory :item do
    name { Faker::Food.dish }
    amount { Faker::Commerce.price(range: 10..100) }
    association :expense
  end
end
