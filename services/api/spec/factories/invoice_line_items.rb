FactoryBot.define do
  factory :invoice_line_item do
    association :invoice
    name { Faker::Commerce.product_name }
    item_type { %w[package add_on].sample }
    quantity { Faker::Number.between(from: 1, to: 5) }
    unit_price { Faker::Commerce.price(range: 50.0..200.0) }
    total_price { quantity * unit_price }
  end
end
