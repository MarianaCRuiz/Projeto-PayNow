class Charge < ApplicationRecord
  belongs_to :company
  belongs_to :product
  belongs_to :final_client
  belongs_to :boleto_register_option, optional: true
  belongs_to :credit_card_register_option, optional: true
  belongs_to :pix_register_option, optional: true
  belongs_to :status_charge
  belongs_to :payment_option
  validates :client_name, :client_cpf, :client_token, :company_token, :product_token, :payment_method, :token,
            presence: true
  validates :card_number, :card_name, :cvv_code, presence: true, if: :paid_with_card?
  validates :client_address, :due_deadline, presence: true, if: :paid_with_boleto?
  validates :payment_date, :authorization_token, presence: true, if: :paid?
  validates :attempt_date, presence: true, if: :attempted?

  def attempted?
    status_returned_code != '05' && !status_returned_code.nil?
  end

  def paid?
    status_returned_code == '05'
  end

  def boleto_option(product, payments)
    boleto = payments[:company].boleto_register_options.find_by(payment_option: payments[:payment_option])
    return unless boleto

    self.discount = price * product.boleto_discount / 100
    self.boleto_register_option = boleto
  end

  def credit_card_option(product, payments)
    credit_card = payments[:company].credit_card_register_options.find_by(payment_option: payments[:payment_option])
    return unless credit_card

    self.discount = price * product.credit_card_discount / 100
    self.credit_card_register_option = credit_card
  end

  def pix_option(product, payments)
    pix = payments[:company].pix_register_options.find_by(payment_option: payments[:payment_option])
    return unless pix

    self.discount = price * product.pix_discount / 100
    self.pix_register_option = pix
  end

  def paid_with_card?
    payment_option.payment_type == 'credit_card' if payment_option
  end

  def paid_with_boleto?
    payment_option.payment_type == 'boleto' if payment_option
  end

  def saving_data(charge_values)
    find_company = charge_values[:company]
    if find_company
      self.status_charge = charge_values[:status]
      self.company = find_company
      self.product = charge_values[:product]
      self.final_client = charge_values[:final_client]
      self.payment_option = charge_values[:payment_option]
    end
    specific_data
  end

  def specific_data
    client_data(final_client)
    product_data(product)
    payments = { payment_option: payment_option, company: company, product: product }
    save_payment_type(**payments)
    save_price_and_discount
  end

  def client_data(final_client)
    return unless final_client

    self.client_name = final_client.name
    self.client_cpf = final_client.cpf
    self.final_client = final_client
  end

  def product_data(product)
    return unless product

    self.price = product.price
    self.product_name = product.name
    self.product = product
  end

  def save_payment_type(payments)
    return unless payments[:payment_option] && payments[:company] && payments[:product]

    self.payment_option = payments[:payment_option]
    boleto_option(payments[:product], payments)
    credit_card_option(payments[:product], payments)
    pix_option(payments[:product], payments)
  end

  def save_price_and_discount
    self.charge_price = if discount
                          price - discount
                        else
                          price
                        end
  end

  def payment(params_charge)
    status_charge = params_charge[:status]
    payment_date = params_charge[:payment_date]
    self.status_returned = status_charge.description
    self.status_returned_code = status_charge.code
    return unless payment_date

    self.payment_date = payment_date
    self.authorization_token = params_charge[:authorization_token]
  end

  def payment_attempt(params_charge)
    status_charge = params_charge[:status]
    attempt_date = params_charge[:attempt_date]
    self.status_returned = status_charge.description
    self.status_returned_code = status_charge.code
    self.status_charge = StatusCharge.find_by(code: '01')
    self.attempt_date = attempt_date if attempt_date
  end

  before_validation(on: :create) do
    loop do
      token = SecureRandom.base58(20)
      break self.token = token unless Charge.exists?(token: token)
    end
  end
end
