class Api::V1::CompaniesController < ActionController::API
  before_action :status_charge_generate, only: %i[charges consult_charges]
  
  def charges
    @status = StatusCharge.find_by(code: '01')
    @charge = Charge.new(charge_params)
    @company = Company.find_by(token: charge_params[:company_token])
    @product = Product.find_by(token: charge_params[:product_token])
    @final_client = FinalClient.find_by(token: charge_params[:client_token])
    @payment_option = PaymentOption.find_by(name: charge_params[:payment_method])
    @charge.status_charge = @status
    @charge.company = @company
    @charge.product = @product
    @charge.final_client = @final_client
    @charge.payment_option = @payment_option
    if @final_client
      @charge.client_name = @final_client.name
      @charge.client_cpf = @final_client.cpf
    end
    if @product && @company && @payment_option
      @charge.price = @product.price
      @boleto = @company.boleto_register_options.find_by(payment_option: @payment_option)
      @credit_card = @company.credit_card_register_options.find_by(payment_option: @payment_option)
      @pix = @company.pix_register_options.find_by(payment_option: @payment_option)
      if @boleto
        @charge.discount = @charge.price*@product.boleto_discount/100
        @charge.boleto_register_option = @boleto
      elsif @credit_card
        @charge.discount = @charge.price*@product.credit_card_discount/100
        @charge.credit_card_register_option = @credit_card
      elsif @pix
        @charge.discount = @charge.price*@product.pix_discount/100
        @charge.pix_register_option = @pix
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
      if @credit_card || @pix
        @charge.due_deadline = @charge.created_at.strftime("%d/%m/%Y")
        @charge.save
      end
      render json: @charge.as_json(only: [:product_name, :price, :discount, :charge_price, 
                                          :client_name, :client_cpf, :payment_method, :token]), status: 201
    end
  rescue ActiveRecord::RecordInvalid
    render json: @charge.errors, status: :precondition_failed
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end

  def final_clients
    @final_client = FinalClient.new(final_client_params)
    @company = Company.find_by(token: params[:company_token])
    @final_client.save!
    @company.company_clients.create!(final_client: @final_client)
    render json: @final_client, status: 201
  rescue ActiveRecord::RecordInvalid                       #ActionController::ParameterMissing
    @client = FinalClient.where(cpf: @final_client.cpf).first
    if @client && CompanyClient.where(company: @company, final_client: @client).empty? && !FinalClient.where(cpf: @client.cpf).empty?
      @final_client = FinalClient.find_by(cpf: @client.cpf)
      @company_client = @company.company_clients.create!(final_client: @client)
      render json: FinalClient.find_by(cpf: @client.cpf), status: 202
    elsif @client && !CompanyClient.where(company: @company, final_client: @client).empty?
      render json: @final_client.errors, status: 409
    else
      render json: @final_client.errors, status: :precondition_failed
    end
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end
    
  def consult_charges
    @company = Company.find_by(token: params[:company_token])
    @due_deadline = consult_params[:due_deadline]
    @due_deadline_max = consult_params[:due_deadline_max]
    @due_deadline_min = consult_params[:due_deadline_min]
    @payment_method = consult_params[:payment_method]
    @payment_option = PaymentOption.find_by(name: @payment_method)
    if consult_params[:status_charge_code]
      @status_charge = StatusCharge.find_by(code: consult_params[:status_charge_code])
    end
    if consult_params[:charge_id]
      @charge = Charge.find_by(token: consult_params[:charge_id])
    end
    if @status_charge || @charge
      @payment_date = consult_params[:payment_date]
      @attempt_date = consult_params[:attempt_date]
      if @charge && @status_charge && @status_charge.code == '05'
        @charge.status_charge = @status_charge
        @charge.status_returned = @status_charge.code
        if @payment_date
          @charge.payment_date = @payment_date
        end
        @charge.save!
        Receipt.create(due_deadline: @charge.due_deadline, payment_date: @payment_date, charge: @charge)
        render json: @charge
      elsif @charge && @status_charge && @status_charge.code != '01'
        @charge.status_returned = @status_charge.code
        @charge.status_charge = StatusCharge.find_by(code: '01')
        if @attempt_date
          @charge.attempt_date = @attempt_date
        end
        @charge.save!
        render json: @charge
      else
        head 404
      end
    else
      if !@payment_method
        if @due_deadline
          @charges = @company.charges.where(due_deadline: @due_deadline)
        elsif @due_deadline_max && @due_deadline_min
          @charges = @company.charges.where("due_deadline <= ? and due_deadline >= ?", @due_deadline_max.to_date.strftime("%Y-%m-%d"), @due_deadline_min.to_date.strftime("%Y-%m-%d"))
        elsif @due_deadline_max
          @charges = @company.charges.where("due_deadline <= ?", @due_deadline_max.to_date.strftime("%Y-%m-%d"))
        elsif @due_deadline_min
          @charges = @company.charges.where("due_deadline >= ?", @due_deadline_min.to_date.strftime("%Y-%m-%d")) 
        else
          @charges = @company.charges
        end
      else
        @charges = @company.charges.where(payment_method: @payment_method)
        if @due_deadline
          @charges = @charges.where(due_deadline: @due_deadline)
        elsif @due_deadline_max && @due_deadline_min
          @charges = @charges.where("due_deadline <= ? and due_deadline >= ?", @due_deadline_max.to_date.strftime("%Y-%m-%d"), @due_deadline_min.to_date.strftime("%Y-%m-%d"))
        elsif @due_deadline_max
          @charges = @charges.where("due_deadline <= ?", @due_deadline_max.to_date.strftime("%Y-%m-%d"))
        elsif @due_deadline_min
          @charges = @charges.where("due_deadline >= ?", @due_deadline_min.to_date.strftime("%Y-%m-%d"))
        end
      end
      if @due_deadline_max && @due_deadline_min && @due_deadline_max < @due_deadline_min
        head 416
      else
        if !@charges.empty?
          render json: @charges
        elsif @payment_method && @company.payment_options.where(name: @payment_method).empty?
          head 404
        else
          render json: @charges, status: 204
        end
      end
    end
  rescue ActiveRecord::RecordInvalid
    render json: @charge.errors, status: :precondition_failed
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end

  private

  def final_client_params
    params.require(:final_client).permit(:name, :cpf)
  end

  def charge_params
    params.require(:charge).permit(:client_token, :company_token, :product_token, 
                                  :payment_method, :boleto_register_option_id, :credit_card_register_option_id, 
                                  :pix_register_option_id, :client_address, :card_number, 
                                  :card_name, :cvv_code, :due_deadline)
  end

  def consult_params
    params.require(:consult).permit(:payment_method, :due_deadline, :due_deadline_min, :due_deadline_max, 
                                    :status_charge_code, :charge_id, :payment_date)
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