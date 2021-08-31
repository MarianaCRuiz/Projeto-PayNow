class CompanyClient < ApplicationRecord
  belongs_to :final_client
  belongs_to :company

  validates :final_client_id, uniqueness: { scope: :company_id }

  has_many :company_clients, dependent: :destroy
  has_many :final_clients, through: :company_clients
end
