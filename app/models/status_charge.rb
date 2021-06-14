class StatusCharge < ApplicationRecord
  validates :code, :description, presence: true, uniqueness: true
end
