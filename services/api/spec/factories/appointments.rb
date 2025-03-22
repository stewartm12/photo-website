FactoryBot.define do
  factory :appointment do
    association :customer
    association :package
    preferred_date_time { Faker::Time.forward(days: 30, period: :morning) }
    additional_notes { Faker::Lorem.sentence }
  end
end
