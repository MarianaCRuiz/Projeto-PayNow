class Charge < ApplicationRecord
  belongs_to :company
  belongs_to :product
  belongs_to :final_client
  belongs_to :boleto_register_option, optional: true
  belongs_to :credit_card_register_option, optional: true
  belongs_to :pix_register_option, optional: true
  belongs_to :status_charge
  belongs_to :payment_option
  
  validates :client_name, :client_cpf, :company_token, :product_token, :payment_method, :due_deadline, :token, presence: true
  validates :card_number, :card_name, :cvv_code, presence: true, if: :paid_with_card?
  validates :client_address, presence: true, if: :paid_with_boleto?
  validates :payment_date, presence: true, if: :paid?
  validates :attempt_date, presence: true, if: :attempted?
  def paid_with_card?
    if self.payment_option
      self.payment_option.payment_type == "credit_card"
    end
  end
  def paid_with_boleto?
    if self.payment_option
      self.payment_option.payment_type == "boleto"
    end
  end
  def paid?
    self.status_returned == "05"
  end
  def attempted?
    self.status_returned != "05" && self.status_returned != nil
  end
  before_validation(on: :create) do
    token = self.token = SecureRandom.base58(20)
    same = true
    while same == true do
      if Charge.where(token: token).empty?
        self.token = token
        same = false
      else
        self.token = SecureRandom.base58(20)
      end
    end
    self.token
  end
end
