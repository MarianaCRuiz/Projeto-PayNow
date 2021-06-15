class StatusCharge < ApplicationRecord
  has_many :charges
  
  validates :code, :description, presence: true, uniqueness: true

  def display_name
    "#{code} - #{description}"
  end
end
