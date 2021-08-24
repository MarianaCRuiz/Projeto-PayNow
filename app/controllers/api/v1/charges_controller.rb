class Api::V1::ChargesController < ActionController::API
  before_action :status_charge_generate
  before_action :find_company

  def charges_generate
    find_contents(charge_params)
    @charge = Charge.new(charge_params)
    @charge.saving_data(setting_values)
    @charge.save!
    @charge.update!(due_deadline: @charge.created_at.strftime('%d/%m/%Y')) if @credit_card || @pix
    render json: @charge, status: :created
  rescue ActiveRecord::RecordInvalid
    render json: @charge.errors, status: :precondition_failed
  end

  private

  def charge_params
    params.require(:charge).permit(:client_token, :company_token, :product_token,
                                   :payment_method, :boleto_register_option_id, :credit_card_register_option_id,
                                   :pix_register_option_id, :client_address, :card_number,
                                   :card_name, :cvv_code, :due_deadline)
  end

  def find_company
    @company = Company.find_by(token: charge_params[:company_token])
    if @company&.blocked?
      render json: { error: 'Não foi possível gerar a cobrança, a conta da empresa na plataforma está bloqueada' },
             status: :forbidden
    end
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end

  def find_contents(charge_params)
    @final_client = FinalClient.find_by(token: charge_params[:client_token])
    @product = Product.find_by(token: charge_params[:product_token])
    @payment_option = PaymentOption.find_by(name: charge_params[:payment_method])
    @status = StatusCharge.find_by(code: '01')
    return unless @payment_option && @company && @product

    find_payment
  end

  def find_payment
    @boleto = @company.boleto_register_options.find_by(payment_option: @payment_option)
    @credit_card = @company.credit_card_register_options.find_by(payment_option: @payment_option)
    @pix = @company.pix_register_options.find_by(payment_option: @payment_option)
    head :precondition_failed if @boleto.nil? && @credit_card.nil? && @pix.nil?
  end

  def setting_values
    { company: @company, final_client: @final_client, product: @product,
      status: @status, payment_option: @payment_option }
  end

  def status_charge_generate
    require 'csv'
    return unless StatusCharge.count < 5

    csv_text = File.read(Rails.root.join('db', 'csv_folder', 'charge_status_options.csv'))
    csv2 = CSV.parse(csv_text, headers: true)
    csv2.each do |row|
      code, description = row.to_s.split(' ', 2)
      StatusCharge.create(code: code, description: description)
    end
  end
end
