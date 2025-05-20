FactoryBot.define do
  factory :collection do
    sequence(:name) { |n| "Collection #{n}" }
    shoot_date { Faker::Date.forward(days: 30) }
    association :gallery
  end
end
