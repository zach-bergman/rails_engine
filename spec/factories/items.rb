FactoryBot.define do
  factory :item do
    name { Faker::Company.name }
    description { Faker::Lorem.sentence }
    unit_price{ Faker::Commerce.price }
    merchant
  end
end