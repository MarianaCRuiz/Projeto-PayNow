class PaymentOption < ApplicationRecord
  enum state: { active: 0, inactive: 1 }
  enum payment_type: { boleto: 0, credit_card: 1, pix: 2 }

  has_one_attached :icon
  after_create_commit :set_photo

  has_many :charges, dependent: :destroy

  has_many :payment_companies, dependent: :destroy
  has_many :companies, through: :payment_companies

  validates :name, :fee, :max_money_fee, presence: true
  validates :name, uniqueness: true

  def set_photo
    return if icon.attached?

    include_boleto?
    include_creditcard?
    include_pix?
  end

  def include_boleto?
    return unless PaymentOption.last.name.include?('Boleto')

    icon.attach(io: File.open(Rails.root.join('app/assets/images/Boleto.png')), filename: 'Boleto.png')
  end

  def include_creditcard?
    return unless PaymentOption.last.name.include?('Cartão de Crédito')

    icon.attach(io: File.open(Rails.root.join('app/assets/images/CreditCard.png')), filename: 'CreditCard.png')
  end

  def include_pix?
    return unless PaymentOption.last.name.include?('PIX') || PaymentOption.last.name.include?('Pix')

    icon.attach(io: File.open(Rails.root.join('app/assets/images/Pix.png')), filename: 'Pix.png')
  end
end
