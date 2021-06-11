class PixRegisterOption < ApplicationRecord
  belongs_to :company
  belongs_to :bank_code
  belongs_to :payment_option

  validates :pix_key, :bank_code_id, :company_id, :payment_option_id, presence: true
  validates :pix_key, uniqueness: {scope: :company_id}
end
