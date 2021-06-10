class BoletoRegisterOption < ApplicationRecord
  belongs_to :company
  belongs_to :bank_code

  validates :bank_code_id, :agency_number, :name, :company_id, :account_number, presence: true
  validates :account_number, uniqueness: {scope: :bank_code}

end
