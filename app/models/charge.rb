class Charge < ApplicationRecord
  belongs_to :company
  belongs_to :product
  belongs_to :final_client
  belongs_to :boleto_register_option, optional: true
  belongs_to :credit_card_register_option, optional: true
  belongs_to :pix_register_option, optional: true
  belongs_to :status_charge
end
