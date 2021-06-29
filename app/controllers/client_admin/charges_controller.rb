class ClientAdmin::ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_client_admin
  before_action :status_charge_generate
  
  def index
    @company = current_user.company
    @status = StatusCharge.find_by(code: '01')
    @charges = @company.charges.where(status_charge: @status)
  end
  
  def all_charges
    @company = current_user.company
    @charges = @company.charges
  end

  def time_interval
    @company = current_user.company
    @status = StatusCharge.all
    gap = Date.today - params[:days].to_i.days
    @charges = @company.charges.where("created_at >= ? and created_at <= ?", gap, Date.today)
  end

  def thirty_days
    @company = current_user.company
    @status = StatusCharge.all
    gap = Date.today - 30.days
    @charges = @company.charges.where("created_at >= ? and created_at <= ?", gap, Date.today)
  end

  def ninety_days
    @company = current_user.company
    @status = StatusCharge.all
    gap = Date.today - 90.days
    @charges = @company.charges.where("created_at >= ? and created_at <= ?", gap, Date.today)
  end

  def edit 
    @charge = Charge.find_by(token: params[:token])
    @status_charges = StatusCharge.all
  end

  def update
    @status_returned = StatusCharge.find(params[:charge][:status_charge_id])
    @charge = Charge.find_by(token: params[:token])
    @charge.status_returned = @status_returned.description
    @charge.status_returned_code = @status_returned.code
    if @charge.update(charge_params)
      if @charge.paid?
        Receipt.create(due_deadline: @charge.due_deadline, payment_date: @charge.payment_date, charge: @charge, authorization_token: @charge.authorization_token)
      elsif @charge.attempted?
        @charge.status_charge = StatusCharge.find_by(code: '01')
        @charge.save
      end
      redirect_to client_admin_charges_path
    else
      @status_charges = StatusCharge.all
      render :edit
    end
  end
  
  private

  def authenticate_client_admin
    redirect_to root_path, notice: 'Acesso não autorizado' unless current_user.client_admin? || current_user.client_admin_sign_up? 
  end

  def charge_params
    params.require(:charge).permit(:status_charge_id, :payment_date, :authorization_token, :attempt_date)
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