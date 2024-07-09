class Invoice < ApplicationRecord
  validates :status, presence: true
  belongs_to :customer
  belongs_to :merchant
end