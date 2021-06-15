class Api::V1::ApiCompaniesController < Api::V1::ApiController
  before_action :status_charge_generate, only: %i[charges]
  def charges
    @status = StatusCharge.find_by(code: '01')
    @charge = Charge.new(charge_params)
    
    @company = Company.find_by(token: charge_params[:company_token])
    @product = Product.find_by(token: charge_params[:product_token])
    @final_client = FinalClient.find_by(cpf: charge_params[:client_cpf])
    @payment_option = PaymentOption.find_by(name: charge_params[:payment_method])
    
    @charge.status_charge = @status
    @charge.company = @company
    @charge.product = @product
    @charge.final_client = @final_client
    @charge.payment_option = @payment_option
    
    if @product && @company && @payment_option
      @charge.price = @product.price
      @boleto = @company.boleto_register_options.find_by(payment_option: @payment_option)
      @credit_card = @company.credit_card_register_options.find_by(payment_option: @payment_option)
      @pix = @company.pix_register_options.find_by(payment_option: @payment_option)
      if @boleto
        @charge.discount = @charge.price*@product.boleto_discount/100
      elsif @credit_card
        @charge.discount = @charge.price*@product.credit_card_discount/100
      elsif @pix
        @charge.discount = @charge.price*@product.pix_discount/100
      end
      @charge.product_name = @product.name
      if  @charge.discount
        @charge.charge_price = @charge.price - @charge.discount
      else
        @charge.charge_price = @charge.price
      end
    end
    if @boleto == nil && @credit_card == nil && @pix == nil
      head 412
    else
      @charge.save!
      render json: @charge.as_json(only: [:product_name, :price, :discount, :charge_price, :client_name, :client_cpf, :payment_method, :token]), status: 201
    end
  rescue ActiveRecord::RecordInvalid
    render json: @charge.errors, status: :precondition_failed
  end


  def final_clients
    @final_client = FinalClient.new(final_client_params)
    @company = Company.find_by(token: params[:company_token])
    @final_client.save!
    @company.company_clients.create!(final_client: @final_client)
    render json: @final_client, status: 201
  rescue ActiveRecord::RecordInvalid                       #ActionController::ParameterMissing
    @client = FinalClient.where(cpf: @final_client.cpf).first

    if @client && CompanyClient.where(company: @company, final_client: @client).empty?
      if !FinalClient.where(cpf: @client.cpf).empty?
        @final_client = FinalClient.where(cpf: @client.cpf).first
        @company_client = @company.company_clients.create!(final_client: @client)
        render json: FinalClient.where(cpf: @client.cpf).first, status: 202
      end
    elsif @client && !CompanyClient.where(company: @company, final_client: @client).empty?
      render json: @final_client.errors, status: 409
    else
      render json: @final_client.errors, status: :precondition_failed
    end
  end
  
  private
  def final_client_params
    params.require(:final_client).permit(:name, :cpf)
  end
  def charge_params
    params.require(:charge).permit(:client_name, :client_cpf, :company_token, :product_token, 
      :payment_method, :boleto_register_option_id, :credit_card_register_option_id, 
      :pix_register_option_id, :client_address, :card_number, 
      :card_name, :cvv_code, :due_deadline)
  end
  def status_charge_generate
    require 'csv'
    if StatusCharge.count < 5
      csv_text = File.read("#{Rails.root}/public/charge_status_options.csv")
      csv2 = CSV.parse(csv_text, :headers => true)
      csv2.each do |row|
        code, description = row.to_s.split(' ', 2)
        status = StatusCharge.create(code: code, description: description)
      end
    end
  end
end