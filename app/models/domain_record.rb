class DomainRecord < ApplicationRecord
  enum status: {allowed: 0, blocked: 1}
  belongs_to :company, optional: true

  validates :email, :email_client_admin, uniqueness: true
end
