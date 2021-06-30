class Product < ApplicationRecord
  enum status: {active: 0, inactive: 1}
  belongs_to :company
  has_many :historic_products
  has_many :charges

  validates :name, :price, :token, :company_id, presence: true, if: :product_active?
  validates :name, :token, uniqueness: {scope: :company_id, allow_blank: true, message: 'Produto já cadastrado'}
  validates :price, :boleto_discount, :pix_discount, :credit_card_discount, numericality: { greater_than_or_equal_to: 0.0 }
  
  def product_active?
    self.active?
  end

  after_save do
    HistoricProduct.create!(product: self, company: self.company, price: self.price, 
                            boleto_discount: self.boleto_discount, 
                            credit_card_discount: self.credit_card_discount, 
                            pix_discount: self.pix_discount)
    
  end
  
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