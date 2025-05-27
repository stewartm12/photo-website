FactoryBot.define do
  factory :appointment_package do
    association :appointment
    name { Faker::Lorem.unique.words(number: 2).join(' ') }
    price { Faker::Commerce.price(range: 50.0..500.0) }
    edited_images { Faker::Number.digit }
    outfit_change { Faker::Boolean.boolean }
    duration { Faker::Number.within(range: 15..120) }
    features { Array.new(Faker::Number.between(from: 1, to: 4)) { Faker::Marketing.buzzwords } }
    gallery_name { Faker::Company.name }
  end
end
