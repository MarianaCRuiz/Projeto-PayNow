class BoletoRegisterOption < ApplicationRecord
  enum status: {active: 0, inactive: 1}
  belongs_to :company
  belongs_to :payment_option
  belongs_to :bank_code

  validates :bank_code_id, :agency_number, :company_id, :account_number, presence: true, if: :boleto_active?
  validates :account_number, uniqueness: {scope: [:bank_code, :agency_number], allow_blank: true}
  
  def boleto_active?
    self.active?
  end
  
end
