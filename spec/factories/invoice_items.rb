FactoryBot.define do
  factory :invoice_item do
    quantity { Faker::Number.between(from: 1, to: 10) }
    unit_price { Faker::Commerce.price }
    item
    invoice
  end
end