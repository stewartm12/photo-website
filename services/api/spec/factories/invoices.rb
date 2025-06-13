FactoryBot.define do
  factory :invoice do
    association :appointment
    invoice_number { Faker::Number.unique.number(digits: 10) }
    subtotal { Faker::Commerce.price(range: 500..1000) }
    tax  { 0 }
    total { subtotal + tax }
    deposit { 100 }
    paid_amount { Faker::Commerce.price(range: 0..total.to_f) }
    status { 'unpaid' }

    trait :unpaid do
      status { 'unpaid' }
      paid_amount { 0 }
    end

    trait :overdue do
      status { 'overdue' }
    end

    trait :paid do
      status { 'paid' }
      paid_amount { total - deposit }
    end

    trait :refunded do
      status { 'refunded' }
    end

    trait :void do
      status { 'void' }
    end
  end
end
