class PixRegisterOption < ApplicationRecord
  enum status: {active: 0, inactive: 1}
  belongs_to :company
  belongs_to :bank_code
  belongs_to :payment_option

  validates :pix_key, :bank_code_id, :company_id, :payment_option_id, presence: true, if: :pix_active?
  validates :pix_key, uniqueness: {scope: :company_id, allow_blank: true}
  def pix_active?
    self.active?
  end
end
