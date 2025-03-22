FactoryBot.define do
  factory :appointment_add_on do
    association :appointment
    association :add_on
    quantity { Faker::Number.between(from: 1, to: 5) }
  end
end
