class Api::V1::CompaniesController < Api::V1::ApiController

  def charges
    @status = StatusCharge.create(code: '01', description: 'Pendente de cobrança')
    @status = StatusCharge.where(code: '01', description: 'Pendente de cobrança').first

    @charge = Charge.new(charge_params)
    @charge.status_charge = @status
    @company = Company.find_by(token: charge_params[:company_token])
    @charge.company = @company
    @product = Product.find_by(token: charge_params[:product_token])
    @charge.product = @product
    @final_client = FinalClient.find_by(cpf: charge_params[:client_cpf])
    @charge.final_client = @final_client
    @charge.price = @product.price

    @boleto = BoletoRegisterOption.find_by(id: charge_params[:boleto_register_option_id])
    @credit_card = CreditCardRegisterOption.find_by(id: charge_params[:credit_card_register_option_id])
    @pix = PixRegisterOption.find_by(id: charge_params[:pix_register_option_id])
    if @boleto
      @charge.payment_method = @boleto.payment_option.name
      @charge.discount = @charge.price*@product.boleto_discount/100
    elsif @credti_card
      @charge.payment_method = @credit.payment_option.name
      @charge.discount = @charge.price*@product.credit_card_discount/100
    elsif @pix
      @charge.payment_method = @pix.payment_option.name
      @charge.discount = @charge.price*@product.pix_discount/100
    end
    @charge.product_name = @product.name
    if  @charge.discount
      @charge.charge_price = @charge.price - @charge.discount
    else
      @charge.charge_price = @charge.price
    end
    if @boleto == nil && @credit_card == nil && @pix == nil
      head 412
    else
      @charge.save!
      render json: @charge.as_json(only: [:product_name, :price, :discount, :charge_price, :client_name, :client_cpf, :payment_method]), status: 201
    end
  end


  def final_clients
    @company = Company.find_by(token: params[:token])
    @final_client = FinalClient.new(final_client_params)
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
      :boleto_register_option_id, :credit_card_register_option_id, :pix_register_option_id, 
      :client_address, :card_number, :card_name, :cvv_code, :due_deadline)
  end
end