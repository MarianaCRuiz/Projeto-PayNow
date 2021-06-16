class Receipt < ApplicationRecord
  belongs_to :charge
  validates :due_deadline, :payment_date, :charge_id, presence: true

  before_validation(on: :create) do 
    authorization_token = self.authorization_token = SecureRandom.base58(20)
    same = true
    while same == true do
      if Receipt.where(authorization_token: authorization_token).empty?
        self.authorization_token = authorization_token
        same = false
      else
        self.authorization_token = SecureRandom.base58(20)
      end
    end
    self.authorization_token
  end
end
