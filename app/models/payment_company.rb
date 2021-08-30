class PaymentCompany < ApplicationRecord
  belongs_to :payment_option
  belongs_to :company

  validates :payment_option, uniqueness: { scope: :company }
end
