class DomainRecord < ApplicationRecord
  enum status: { allowed: 0, blocked: 1 }
  belongs_to :company, optional: true

  validates :email, uniqueness: { scope: :domain, allow_blank: true }

  validates :email_client_admin, uniqueness: { scope: :domain, allow_blank: true }
end
