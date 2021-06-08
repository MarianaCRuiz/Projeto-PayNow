class Admin < ApplicationRecord
  enum permitted: {allowed: 0, rejected: 1}
  validates :email, format: { with: /\A[A-Za-z0-9+_.-]+@paynow.com.br\z/, message: "dominio deve ser paynow.com.br"}, presence: true
end
