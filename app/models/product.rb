class Product < ApplicationRecord
  belongs_to :company
  has_many :historic_products
  has_many :charges

  validates :name, :price, :token, :company_id, presence: true
  validates :name, :token, uniqueness: {scope: :company_id, message: 'Produto já cadastrado'}
  validates :boleto_discount, :pix_discount, :credit_card_discount, numericality: { greater_than_or_equal_to: 0.0 }
  
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