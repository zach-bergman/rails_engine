FactoryBot.define do
  factory :invoice do
    status { ['shipped', 'packaged', 'pending'].sample }
    merchant
    customer
  end
end