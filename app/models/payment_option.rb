class PaymentOption < ApplicationRecord
  enum state: { active: 0, inactive: 1 }
  enum payment_type: { boleto: 0, credit_card: 1, pix: 2 }

  has_one_attached :icon
  after_create_commit :set_photo

  has_many :charges

  has_many :payment_companies
  has_many :companies, through: :payment_companies

  validates :name, :fee, :max_money_fee, presence: true
  validates :name, uniqueness: true

  def set_photo
    return if icon.attached?

    if PaymentOption.last.name.include?('Boleto')
      icon.attach(io: File.open(Rails.root.join('app/assets/images/Boleto.png')), filename: 'Boleto.png')
    elsif PaymentOption.last.name.include?('Cartão de Crédito')
      icon.attach(io: File.open(Rails.root.join('app/assets/images/CreditCard.png')), filename: 'CreditCard.png')
    elsif PaymentOption.last.name.include?('PIX') || PaymentOption.last.name.include?('Pix')
      icon.attach(io: File.open(Rails.root.join('app/assets/images/Pix.png')), filename: 'Pix.png')
    end
  end
end
