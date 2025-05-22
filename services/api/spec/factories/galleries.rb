FactoryBot.define do
  factory :gallery do
    association :store

    name { Faker::Lorem.unique.words(number: 2).join(' ') }
    description { Faker::Lorem.paragraph }
    slug { name.parameterize }
    active { Faker::Boolean.boolean }
    collections_count { 0 }
    packages_count { 0 }
    add_ons_count { 0 }
  end
end
