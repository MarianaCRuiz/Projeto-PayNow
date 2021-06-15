class ClientAdmin::ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :status_charge_generate, only: %i[edit]
  def index
    if current_user.client_admin? || current_user.client_admin_sign_up?
      @company = current_user.company
      @status = StatusCharge.find_by(code: '01')
      @charges = @company.charges.where(status_charge: @status)
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  
  def all_charges
    if current_user.client_admin? || current_user.client_admin_sign_up?
      @company = current_user.company
      @charges = @company.charges
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def edit
    if current_user.client_admin? || current_user.client_admin_sign_up? 
      @charge = Charge.find_by(token: params[:token])
      @status_charges = StatusCharge.all
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  
  def update
    if current_user.client_admin? || current_user.client_admin_sign_up?
      @status_returned = StatusCharge.find(params[:charge][:status_charge_id])
      @charge = Charge.find_by(token: params[:token])
      @charge.status_returned = @status_returned.code
      if @status_returned.code != '05'
        @charge.status_charge = StatusCharge.find_by(code: '01')
      end
      if @charge.update(charge_params)
        redirect_to client_admin_charges_path
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
    params.require(:charge).permit(:status_charge_id, :payment_date, :attempt_date)
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