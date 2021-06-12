class FinalClient < ApplicationRecord
  has_many :company_clients
  has_many :companies, through: :company_clients

  validates :name, :cpf, :token, presence: true

  before_validation(on: :create) do
    token = self.token = SecureRandom.base58(20)
    same = true
    while same == true do
      if FinalClient.where(token: token).empty?
        self.token = token
        same = false
      else
        self.token = SecureRandom.base58(20)
      end
    end
    self.token
  end

  #before_create do    #before_validate ou before_save
  #  self.token = SecureRandom.base58(20)
  #end
end
