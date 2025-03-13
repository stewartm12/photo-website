FactoryBot.define do
  factory :collection do
    sequence(:name) { |n| "Collection #{n}" }
    association :gallery
  end
end
