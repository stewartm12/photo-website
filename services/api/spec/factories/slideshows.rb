FactoryBot.define do
  factory :slideshow do
    name { "homepage" }
    description { "A description of the slideshow" }
    active { false }

    trait :active do
      active { true }
    end
  end
end
