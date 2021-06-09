class Product < ApplicationRecord
  belongs_to :company
  has_many :historic_products
  
  before_create do    #before_validate ou before_save
    self.token = SecureRandom.base58(20)
  end
end
