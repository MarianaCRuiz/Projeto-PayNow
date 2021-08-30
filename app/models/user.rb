class User < ApplicationRecord
  belongs_to :company, optional: true

  validates :email, presence: true, email: true
  validates :email, uniqueness: true

  enum role: { client: 0, client_admin: 1, admin: 2, client_admin_sign_up: 3, blocked: 4 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create do
    domain = email.split('@').last
    if domain == 'paynow.com.br' && !Admin.where(email: email).empty?
      admin!
    elsif DomainRecord.where(domain: domain).empty?
      client_admin_sign_up!
      DomainRecord.create!(email_client_admin: email, domain: domain)
    elsif DomainRecord.find_by(email: email).blank?
      client!
      company = DomainRecord.where(domain: domain).first.company
      self.company = company
      save
      DomainRecord.create(email: email, domain: domain, company: company)
    end
  end
end
