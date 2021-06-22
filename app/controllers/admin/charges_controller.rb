class Admin::ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :status_charge_generate
  
  def index
    if current_user.admin?
      @company = Company.find_by(token: params[:company_token])
      @status = StatusCharge.find_by(code: '01')
      @charges = @company.charges.where(status_charge: @status)
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  
  def all_charges
    if current_user.admin?
      @company = Company.find_by(token: params[:company_token])
      @charges = @company.charges
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def edit
    if current_user.admin? 
      @company = Company.find_by(token: params[:company_token])
      @charge = Charge.find_by(token: params[:token])
      @status_charges = StatusCharge.all
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def update
    if current_user.admin?
      @company = Company.find_by(token: params[:company_token])
      @status_returned = StatusCharge.find(params[:charge][:status_charge_id])
      @charge = Charge.find_by(token: params[:token])
      @charge.status_returned = @status_returned.description
      @charge.status_returned_code = @status_returned.code
      if @charge.update(charge_params)
        if @status_returned.code != '05'
          @charge.status_charge = StatusCharge.find_by(code: '01')
          @charge.save
        end
        if @status_returned.code == '05'
          @authorization_token = charge_params[:authorization_token]
          @charge.authorization_token = @authorization_token
          @charge.save
          Receipt.create(due_deadline: @charge.due_deadline, payment_date: @charge.payment_date, charge: @charge, authorization_token: @authorization_token)
        end 
        redirect_to admin_charges_path(company_token: @company.token)
      else
        @status_charges = StatusCharge.all
        render :edit
      end
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  
  private
  def charge_params
    params.require(:charge).permit(:status_charge_id, :payment_date, :authorization_token, :attempt_date)
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