class PaymentOption < ApplicationRecord
  enum state: {active: 0, inactive: 1}
  has_one_attached :icon
  has_many :payment_companies
  has_many :companies, through: :payment_companies
end
