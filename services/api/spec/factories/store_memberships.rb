FactoryBot.define do
  factory :store_membership do
    association :user
    association :store
  end
end
