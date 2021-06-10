class PixRegisterOption < ApplicationRecord
  belongs_to :company
  belongs_to :bank_code

  validates :pix_key, :bank_code_id, :name, :company_id, presence: true
  validates :pix_key, uniqueness: {scope: :company}

end