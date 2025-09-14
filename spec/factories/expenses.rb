FactoryBot.define do
  factory :expense do
    description { Faker::Lorem.sentence }
    tax { Faker::Commerce.price(range: 1..10) }
    association :user

    # Create at least one item so validation passes
    after(:build) do |expense|
      expense.items << build(:item, expense: expense) if expense.items.empty?
    end
  end
end
