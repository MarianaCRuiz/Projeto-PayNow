class Receipt < ApplicationRecord
  belongs_to :charge
  
  validates :due_deadline, :payment_date, :charge_id, :authorization_token, presence: true

end
