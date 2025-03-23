FactoryBot.define do
  factory :location do
    association :appointment
    address { Faker::Address.full_address }
    note { Faker::Lorem.sentence }
  end
end
