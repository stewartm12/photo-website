FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email_address { Faker::Internet.unique.email }
    password { "Password123!" }
    password_confirmation { "Password123!" }
    confirmed_at { Time.current }
    confirmation_sent_at { Time.current }
  end
end
