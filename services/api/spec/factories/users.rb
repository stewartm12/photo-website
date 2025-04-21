FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email_address { Faker::Internet.unique.email }
    password { "password123" }
    password_confirmation { "password123" }
    confirmed_at { Time.current }
    confirmation_sent_at { Time.current }

    trait :unconfirmed do
      confirmed_at { nil }
      confirmation_sent_at { nil }
    end
  end
end
