class Company < ApplicationRecord
  enum status: { allowed: 0, blocked: 1 }

  has_many :users, dependent: :destroy

  has_many :charges, dependent: :destroy

  has_many :boleto_register_options, dependent: :destroy
  has_many :credit_card_register_options, dependent: :destroy
  has_many :pix_register_options, dependent: :destroy

  has_many :products, dependent: :destroy
  has_many :historic_products, dependent: :destroy

  has_many :domain_records, dependent: :destroy

  has_many :payment_companies, dependent: :destroy
  has_many :payment_options, through: :payment_companies

  has_many :company_clients, dependent: :destroy
  has_many :final_clients, through: :company_clients

  validates :corporate_name, :cnpj, :state, :city, :district, :street, :number, :billing_email, :token, presence: true
  validates :corporate_name, :cnpj, :billing_email, uniqueness: true
  validates :cnpj, format: { with: %r{\A\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}\z}, message: 'formato XX.XXX.XXX/XXXX-XX' }

  before_validation :generate_token, on: :create

  after_save do
    @historic = HistoricCompany.new(corporate_name: corporate_name, cnpj: cnpj,
                                    state: state, city: city,
                                    district: district, street: street,
                                    number: number, address_complement: address_complement,
                                    billing_email: billing_email, token: token,
                                    company: self)
    @historic.save!
  end

  def generate_token
    self.token = SecureRandom.base58(20)
    token = self.token
    same = true
    while same == true
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
