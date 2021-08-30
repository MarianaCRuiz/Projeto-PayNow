class ClientAdmin::ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_client_admin
  before_action :status_charge_generate
  before_action :find_company
  before_action :find_charge, only: %i[edit update]

  def index
    @status = StatusCharge.find_by(code: '01')
    @charges = @company.charges.where(status_charge: @status)
  end

  def all_charges
    @charges = @company.charges
  end

  def time_interval
    @status = StatusCharge.all
    gap = Time.zone.today - params[:days].to_i.days
    @charges = @company.charges.where('created_at >= ? and created_at <= ?', gap, Time.zone.today)
  end

  def edit
    @status_charges = StatusCharge.all
  end

  def update
    @status_returned = StatusCharge.find(params[:charge][:status_charge_id])
    save_params
    if @charge.update(charge_params)
      check_status
      redirect_to client_admin_charges_path(company_token: @company.token)
    else
      @status_charges = StatusCharge.all
      render :edit
    end
  end

  private

  def authenticate_client_admin
    return if current_user.client_admin? || current_user.client_admin_sign_up?

    redirect_to root_path, notice: 'Acesso não autorizado'
  end

  def charge_params
    params.require(:charge).permit(:status_charge_id, :payment_date, :authorization_token, :attempt_date)
  end

  def find_company
    @company = current_user.company
  end

  def find_charge
    @charge = Charge.find_by(token: params[:token])
  end

  def save_params
    @charge.status_returned = @status_returned.description
    @charge.status_returned_code = @status_returned.code
  end

  def generate_receipt
    Receipt.create(due_deadline: @charge.due_deadline, payment_date: @charge.payment_date, charge: @charge,
                   authorization_token: @charge.authorization_token)
  end

  def check_status
    if @charge.paid? then generate_receipt
    elsif @charge.attempted? then @charge.update!(status_charge: StatusCharge.find_by(code: '01'))
    end
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
