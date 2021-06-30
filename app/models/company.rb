class Company < ApplicationRecord
  enum status: {allowed: 0, blocked: 1}
  
  has_many :users
 
  has_many :charges

  has_many :boleto_register_options
  has_many :credit_card_register_options
  has_many :pix_register_options

  has_many :products
  has_many :historic_products

  has_many :domain_records

  has_many :payment_companies
  has_many :payment_options, through: :payment_companies

  has_many :company_clients
  has_many :final_clients, through: :company_clients
  
  validates :corporate_name, :cnpj, :state, :city, :district, :street, :number, :billing_email, :token, presence: true
  validates :corporate_name, :cnpj, :billing_email, uniqueness: true
  validates :cnpj, format: { with: /\A\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}\z/, message: "formato XX.XXX.XXX/XXXX-XX"}

  before_validation :generate_token, on: :create
  
  after_save do
    @historic = HistoricCompany.new(corporate_name: self.corporate_name, cnpj: self.cnpj, 
                                    state: self.state, city: self.city, 
                                    district: self.district, street: self.street, 
                                    number: self.number, address_complement: self.address_complement, 
                                    billing_email: self.billing_email, token: self.token, 
                                    company: self)
    @historic.save!
  end

  def generate_token
    self.token = SecureRandom.base58(20)
    token = self.token
    same = true
    while same == true do
      if Company.where(token: token).empty?
        self.token = token
        same = false
      else
        self.token = SecureRandom.base58(20)
      end
    end
    self.token
  end
end