FactoryBot.define do
  factory :photo do
    sequence(:file_key) { |n| "image_#{n}.jpg" }
    alt_text { "Sample alt text" }
    association :imageable, factory: :gallery

    trait :for_collection do
      association :imageable, factory: :collection
    end

    trait :with_image do
      after(:build) do |photo|
        photo.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.jpg')),
          filename: 'test.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
