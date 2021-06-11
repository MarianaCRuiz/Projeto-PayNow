class FinalClient < ApplicationRecord
  has_many :company_clients
  has_many :companies, through: :company_clients

  #before_create do    #before_validate ou before_save
  #  self.token = SecureRandom.base58(20)
  #end
end
