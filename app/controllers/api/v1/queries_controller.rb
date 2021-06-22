class Api::V1::QueriesController < ActionController::API
  before_action :status_charge_generate     #, only: %i[consult_charges change_status]
  
  def consult_charges
    @company = Company.find_by(token: params[:company_token])
    @due_deadline = consult_params[:due_deadline]
    @due_deadline_max = consult_params[:due_deadline_max]
    @due_deadline_min = consult_params[:due_deadline_min]
    @payment_method = consult_params[:payment_method]
    @payment_option = PaymentOption.find_by(name: @payment_method)
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
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end
  
  def change_status
    @status_charge = StatusCharge.find_by(code: charge_status_params[:status_charge_code])
    @charge = Charge.find_by(token: charge_status_params[:charge_id])
    @payment_date = charge_status_params[:payment_date]
    @attempt_date = charge_status_params[:attempt_date]
    if @charge && @status_charge && @status_charge.code == '05'
      @charge.status_charge = @status_charge
      @charge.status_returned = @status_charge.description
      @charge.status_returned_code = @status_charge.code
      if @payment_date
        @charge.payment_date = @payment_date
        @authorization_token = charge_status_params[:authorization_token]
        @charge.authorization_token = @authorization_token
      end
      @charge.save!
      Receipt.create(due_deadline: @charge.due_deadline, payment_date: @payment_date, charge: @charge, authorization_token: @authorization_token)
      render json: @charge
    elsif @charge && @status_charge && @status_charge.code != '01'
      @charge.status_returned = @status_charge.description
      @charge.status_returned_code = @status_charge.code
      @charge.status_charge = StatusCharge.find_by(code: '01')
      if @attempt_date
        @charge.attempt_date = @attempt_date
      end
      @charge.save!
      render json: @charge
    else
      head 404
    end
  rescue ActiveRecord::RecordInvalid
    render json: @charge.errors, status: :precondition_failed
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end
  
  private
  
  def consult_params
    params.require(:consult).permit(:payment_method, :due_deadline, :due_deadline_min, :due_deadline_max)
  end
  
  def charge_status_params
    params.require(:charge_status).permit(:status_charge_code, :charge_id, :payment_date, :attempt_date, :authorization_token)
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