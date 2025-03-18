FactoryBot.define do
  factory :add_on do
    sequence(:name) { |n| "Add On #{n}" }
    price { Faker::Commerce.price(range: 50.0..200.0) }
    limited { Faker::Boolean.boolean }
    association :gallery
  end
end
