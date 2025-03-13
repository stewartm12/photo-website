FactoryBot.define do
  factory :photo do
    sequence(:file_key) { |n| "image_#{n}.jpg" }
    alt_text { "Sample alt text" }
    association :imageable, factory: :gallery

    trait :for_collection do
      association :imageable, factory: :collection
    end
  end
end
