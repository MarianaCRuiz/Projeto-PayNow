class FinalClient < ApplicationRecord
  before_validation :generate_token, on: :create

  has_many :company_clients, dependent: :destroy
  has_many :companies, through: :company_clients

  validates :name, :cpf, presence: true
  validates :token, :cpf, uniqueness: { allow_blank: true }
  validates :cpf, format: { with: /\A\d{11}\z/, message: 'apenas os números, 11 caracteres' }

  # before_create do   before_validate ou before_save
  def generate_token
    if FinalClient.where(cpf: cpf).empty?
      loop do
        token = SecureRandom.base58(20)
        break self.token = token unless FinalClient.exists?(token: token)
      end
    else
      self.token = FinalClient.where(cpf: cpf).first.token
    end
  end
end
