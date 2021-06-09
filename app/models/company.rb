class Company < ApplicationRecord
  has_many :users
  has_many :products
  
  belongs_to :domain_record, optional: true

  has_many :payment_companies
  has_many :payment_options, through: :payment_companies

  has_many :boleto_register_options

  has_many :credit_card_register_options

  has_many :pix_register_options

  has_many :historic_products
  
  validates :corporate_name, :cnpj, :state, :city, :district, :street, :number, :billing_email, presence: true

  validates :corporate_name, :cnpj, :billing_email, uniqueness: true

  before_create do    #before_validate ou before_save
    self.token = SecureRandom.base58(20)
  end
end
