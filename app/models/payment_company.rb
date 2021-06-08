class PaymentCompany < ApplicationRecord
  belongs_to :payment_option
  belongs_to :company
end
