class Admin < ApplicationRecord
  validates :email, format: { with: /\A[A-Za-z0-9+_.-]+@paynow.com.br\z/, message: "dominio deve ser paynow.com.br"}, presence: true
  validates :email, uniqueness: true
end
