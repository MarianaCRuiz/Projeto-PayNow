class Clients::ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :status_charge_generate
  
  def index
    if current_user.client?
      @company = current_user.company
      @status = StatusCharge.find_by(code: '01')
      @charges = @company.charges.where(status_charge: @status)
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  
  def all_charges
    if current_user.client?
      @company = current_user.company
      @charges = @company.charges
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def thirty_days
    if current_user.client?
      @company = current_user.company
      @status = StatusCharge.all
      gap = Date.today - 30.days
      @charges = @company.charges.where("created_at >= ? and created_at <= ?", gap, Date.today)
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def ninety_days
    if current_user.client?
      @company = current_user.company
      @status = StatusCharge.all
      gap = Date.today - 90.days
      @charges = @company.charges.where("created_at >= ? and created_at <= ?", gap, Date.today)
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
      csv_text = File.read("#{Rails.root}/db/csv_folder/charge_status_options.csv")
      csv2 = CSV.parse(csv_text, :headers => true)
      csv2.each do |row|
        code, description = row.to_s.split(' ', 2)
        status = StatusCharge.create(code: code, description: description)
      end
    end
  end
end