class Charge < ApplicationRecord
  belongs_to :company
  belongs_to :product
  belongs_to :final_client
  belongs_to :boleto_register_option, optional: true
  belongs_to :credit_card_register_option, optional: true
  belongs_to :pix_register_option, optional: true
  belongs_to :status_charge
  validates :client_name, :client_cpf, :company_token, :product_token, presence: true
  validates :card_number, :card_name, :cvv_code, presence: true, if: :paid_with_card?
  validates :client_address, presence: true, if: :paid_with_boleto?
  def paid_with_card?
    self.payment_method == "credit_card"
  end
  def paid_with_boleto?
    self.payment_method == "boleto"
  end
end
