class StatusCharge < ApplicationRecord
  has_many :charges, dependent: :destroy

  validates :code, :description, presence: true, uniqueness: true

  def display_name
    "#{code} - #{description}"
  end
end
