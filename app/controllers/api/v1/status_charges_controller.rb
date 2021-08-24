class Api::V1::StatusChargesController < ActionController::API
  before_action :status_charge_generate

  def change_status
    @paid = false
    @status_charge = StatusCharge.find_by(code: charge_status_params[:status_charge_code])
    @charge = Charge.find_by(token: charge_status_params[:charge_id])
    if @charge && @status_charge
      charge_paid?
      charge_attempt?
      @charge.save!
      render json: @charge
      if @paid == true
        Receipt.create(due_deadline: @charge.due_deadline, payment_date: @payment_date, charge: @charge,
                       authorization_token: @authorization_token)
      end
    else
      head :not_found
    end
  rescue ActiveRecord::RecordInvalid
    render json: @charge.errors, status: :precondition_failed
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end

  private

  def charge_status_params
    params.require(:charge_status).permit(:status_charge_code, :charge_id, :payment_date, :attempt_date,
                                          :authorization_token)
  end

  def charge_paid?
    if @status_charge.code == '05'
      @payment_date = charge_status_params[:payment_date]
      @charge.status_charge = @status_charge
      @charge.status_returned = @status_charge.description
      @charge.status_returned_code = @status_charge.code
      if @payment_date
        @charge.payment_date = @payment_date
        @authorization_token = charge_status_params[:authorization_token]
        @charge.authorization_token = @authorization_token
      end
      @paid = true
    end
  end

  def charge_attempt?
    @attempt_date = charge_status_params[:attempt_date]
    if @status_charge.code != '01'
      @charge.status_returned = @status_charge.description
      @charge.status_returned_code = @status_charge.code
      @charge.status_charge = StatusCharge.find_by(code: '01')
      @charge.attempt_date = @attempt_date if @attempt_date
    end
  end

  def status_charge_generate
    require 'csv'
    if StatusCharge.count < 5
      csv_text = File.read("#{Rails.root}/db/csv_folder/charge_status_options.csv")
      csv2 = CSV.parse(csv_text, headers: true)
      csv2.each do |row|
        code, description = row.to_s.split(' ', 2)
        status = StatusCharge.create(code: code, description: description)
      end
    end
  end
end
