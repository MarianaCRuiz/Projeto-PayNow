class Product < ApplicationRecord
  belongs_to :company
  has_many :historic_products

  validates :name, :price, :token, :company_id, presence: true
  validates :name, :token, uniqueness: {scope: :company_id, message: 'Produto já cadastrado'}
  
  before_validation(on: :create) do
    token = self.token = SecureRandom.base58(20)
    same = true
    while same == true do
      if Product.where(token: token).empty?
        self.token = token
        same = false
      else
        self.token = SecureRandom.base58(20)
      end
    end
    self.token
  end
end
