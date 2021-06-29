class Api::V1::ChargesController < ActionController::API
  before_action :status_charge_generate
  
  def charges_generate
    @company = Company.find_by(token: charge_params[:company_token])
    if @company && @company.blocked?
      render json: {error: "Não foi possível gerar a combrança, a conta da empresa na plataforma está bloqueada"}, status: 403
    else
      @status = StatusCharge.find_by(code: '01')
      @charge = Charge.new(charge_params)
      save_charge_data
      save_final_client_data
      save_product_data
      save_payment_type
      save_price_and_discount
      if @boleto == nil && @credit_card == nil && @pix == nil then head 412
      else @charge.save!
        if @credit_card || @pix
          @charge.due_deadline = @charge.created_at.strftime("%d/%m/%Y")
          @charge.save
        end
        render json: @charge, status: 201
      end
    end
  rescue ActiveRecord::RecordInvalid
    render json: @charge.errors, status: :precondition_failed
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end

  private

  def charge_params
    params.require(:charge).permit(:client_token, :company_token, :product_token, 
                                  :payment_method, :boleto_register_option_id, :credit_card_register_option_id, 
                                  :pix_register_option_id, :client_address, :card_number, 
                                  :card_name, :cvv_code, :due_deadline)
  end

  def save_charge_data
    if @company
      @charge.status_charge = @status
      @charge.company = @company
      @charge.product = @product
      @charge.final_client = @final_client
      @charge.payment_option = @payment_option
    end
  end

  def save_final_client_data
    @final_client = FinalClient.find_by(token: charge_params[:client_token])
    if @final_client
      @charge.client_name = @final_client.name
      @charge.client_cpf = @final_client.cpf
      @charge.final_client = @final_client
    end
  end
  
  def save_product_data
    @product = Product.find_by(token: charge_params[:product_token])
    if @product
      @charge.price = @product.price
      @charge.product_name = @product.name
      @charge.product = @product
    end
  end

  def save_payment_type
    @payment_option = PaymentOption.find_by(name: charge_params[:payment_method])
    if @payment_option && @company && @product
      @charge.payment_option = @payment_option
      @boleto = @company.boleto_register_options.find_by(payment_option: @payment_option)
      @credit_card = @company.credit_card_register_options.find_by(payment_option: @payment_option)
      @pix = @company.pix_register_options.find_by(payment_option: @payment_option)
      if @boleto then @charge.boleto(@product, @boleto)
      elsif @credit_card then @charge.credit_card(@product, @credit_card)
      elsif @pix then @charge.pix(@product, @pix) end
    end
  end

  def save_price_and_discount
    if  @charge.discount
      @charge.charge_price = @charge.price - @charge.discount
    else
      @charge.charge_price = @charge.price
    end
  end
  
  def status_charge_generate
    require 'csv'
    if StatusCharge.count < 5
      csv_text = File.read("#{Rails.root}/db/csv_folder/charge_status_options.csv")
      csv2 = CSV.parse(csv_text, :headers => true)
      csv2.each do |row|
        code, description = row.to_s.split(' ', 2)
        status = StatusCharge.create(code: code, description: description)
      end
    end
  end
end