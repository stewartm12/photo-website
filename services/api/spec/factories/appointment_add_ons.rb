FactoryBot.define do
  factory :appointment_add_on do
    association :appointment
    quantity { Faker::Number.between(from: 1, to: 5) }
    name { Faker::Lorem.unique.words(number: 2).join(' ') }
    price { Faker::Commerce.price(range: 50.0..500.0) }
    limited { Faker::Boolean.boolean }
  end
end
