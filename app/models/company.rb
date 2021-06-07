class Company < ApplicationRecord
  before_create do
    self.token = SecureRandom.base58(20)
  end
end
