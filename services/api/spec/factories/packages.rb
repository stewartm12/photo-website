FactoryBot.define do
  factory :package do
    sequence(:name) { |n| "Package #{n}" }
    price { Faker::Commerce.price(range: 50.0..500.0) }
    edited_images { Faker::Number.between(from: 10, to: 100) }
    outfit_change { Faker::Boolean.boolean }
    duration { Faker::Number.between(from: 30, to: 120) }
    popular { Faker::Boolean.boolean }
    features { Array.new(Faker::Number.between(from: 1, to: 4)) { Faker::Marketing.buzzwords } }
    association :gallery
  end
end
