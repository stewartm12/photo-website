FactoryBot.define do
  factory :appointment_event do
    appointment { nil }
    user { nil }
    event_type { "MyString" }
    message { "MyText" }
    metadata { "" }
  end
end
