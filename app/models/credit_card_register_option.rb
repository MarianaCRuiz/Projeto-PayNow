class CreditCardRegisterOption < ApplicationRecord
  enum status: { active: 0, inactive: 1 }
  belongs_to :company
  belongs_to :payment_option

  validates :company_id, :credit_card_operator_token, :payment_option_id, presence: true, if: :credit_card_active?
  validates :credit_card_operator_token, uniqueness: { scope: :company_id, allow_blank: true }

  def credit_card_active?
    active?
  end
end
