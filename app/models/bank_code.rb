class BankCode < ApplicationRecord
  has_many :pix_register_options, dependent: :destroy
  has_many :boleto_register_options, dependent: :destroy

  validates :code, :bank, uniqueness: true

  def display_name
    "#{code} - #{bank}"
  end
end
