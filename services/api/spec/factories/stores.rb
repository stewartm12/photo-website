FactoryBot.define do
  factory :store do
    association :owner, factory: :user

    name { Faker::Company.name }
    domain { Faker::Internet.unique.domain_name }
    slug { name.parameterize }
  end
end
