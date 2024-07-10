class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items

  def self.find_merchant_by_name(name)
    where('name ILIKE ?', "%#{name}%")
    .order('name ASC')
    .first
  end
end
