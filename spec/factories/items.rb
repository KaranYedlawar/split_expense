FactoryBot.define do
  factory :item do
    name { Faker::Food.dish }
    amount { 20.to_d }
    association :expense
  end
end
