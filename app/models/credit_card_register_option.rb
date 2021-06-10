class CreditCardRegisterOption < ApplicationRecord
  belongs_to :company

  validates :credit_card_operator_token, presence: true
  validates :credit_card_operator_token, uniqueness: {scope: :company}
end
