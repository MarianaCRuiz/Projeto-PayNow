class PaymentOption < ApplicationRecord
  enum state: {active: 0, inactive: 1}

  has_one_attached :icon
  after_create_commit :set_photo
  
  has_many :payment_companies
  has_many :companies, through: :payment_companies

  validates :name, :fee, :max_money_fee, presence: true
  validates :name, uniqueness: true

  def set_photo
    return if icon.attached?
    if PaymentOption.last.name.include?('Boleto')
      icon.attach(io: File.open(Rails.root.join('app/assets/images/Boleto.jpg')), filename: 'Boleto.jpg')
    elsif PaymentOption.last.name.include?('Cartão de Crédito')
      icon.attach(io: File.open(Rails.root.join('app/assets/images/CreditCard.jpg')), filename: 'CreditCard.jpg')
    elsif PaymentOption.last.name.include?('PIX') || PaymentOption.last.name.include?('Pix')
      icon.attach(io: File.open(Rails.root.join('app/assets/images/Pix.png')), filename: 'Pix.png')
    end
  end
end
