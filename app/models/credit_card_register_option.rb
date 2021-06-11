class CreditCardRegisterOption < ApplicationRecord
  belongs_to :company
  belongs_to :payment_option

  validates :company_id, :credit_card_operator_token, :payment_option_id, presence: true
  validates :credit_card_operator_token, uniqueness: {scope: :company_id}
end
