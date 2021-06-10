class PixRegisterOption < ApplicationRecord
  belongs_to :company
  belongs_to :bank_code

  validates :pix_key, :bank_code, presence: true
  validates :pix_key, uniqueness: {scope: :company}

end
