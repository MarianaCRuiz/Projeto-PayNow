class Api::V1::StatusChargesController < ActionController::API
  before_action :status_charge_generate
  before_action :find_contents

  def change_status
    return head :not_found unless @charge && @status_charge

    charge_paid?
    charge_attempt?
    @charge.save!
    generate_receipt
    render json: @charge
  rescue ActiveRecord::RecordInvalid
    render json: @charge.errors, status: :precondition_failed
  end

  private

  def charge_status_params
    params.require(:charge_status).permit(:status_charge_code, :charge_id, :payment_date, :attempt_date,
                                          :authorization_token)
  end

  def find_contents
    @paid = false
    @status_charge = StatusCharge.find_by(code: charge_status_params[:status_charge_code])
    @charge = Charge.find_by(token: charge_status_params[:charge_id])
    @payment_date = charge_status_params[:payment_date]
    @authorization_token = charge_status_params[:authorization_token]
    @attempt_date = charge_status_params[:attempt_date]
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end

  def charge_paid?
    return @paid = false unless @status_charge.code == '05'

    params_charge = { status: @status_charge, payment_date: @payment_date, authorization_token: @authorization_token }
    @charge.payment(params_charge)
    @paid = true
  end

  def charge_attempt?
    return @paid = false unless @status_charge.code != '01' && @status_charge.code != '05'

    params_charge = { status: @status_charge, attempt_date: @attempt_date }
    @charge.payment_attempt(params_charge)
    @paid = true
  end

  def generate_receipt
    return unless @paid == true

    Receipt.create(due_deadline: @charge.due_deadline, payment_date: @payment_date, charge: @charge,
                   authorization_token: @authorization_token)
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
