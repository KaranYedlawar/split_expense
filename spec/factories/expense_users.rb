FactoryBot.define do
  factory :expense_user do
    association :expense
    association :user
    share_amount { 10.to_d }
  end
end
