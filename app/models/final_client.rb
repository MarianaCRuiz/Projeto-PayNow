class FinalClient < ApplicationRecord
  before_validation :generate_token, on: :create
  #before_validation :generate_token_api, on: :final_clients

  has_many :company_clients
  has_many :companies, through: :company_clients

  validates :name, :cpf, presence: true
  validates :token, :cpf, uniqueness: 

  def generate_token    #before_create do   before_validate ou before_save
    if FinalClient.where(cpf: self.cpf).empty?
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
    else
      self.token = FinalClient.where(cpf: self.cpf).first.token
    end
    self.token 
  end
end
