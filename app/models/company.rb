class Company < ApplicationRecord
  has_many :users
  belongs_to :domain_record, optional: true

  has_many :payment_companies
  has_many :payment_options, through: :payment_companies


  before_create do    #before_validate ou before_save
    self.token = SecureRandom.base58(20)
  end
end
