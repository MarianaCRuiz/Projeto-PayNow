class Clients::ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_client
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
    gap = Time.zone.today - params[:days].to_i.days
    @charges = @company.charges.where('created_at >= ? and created_at <= ?', gap, Time.zone.today)
  end

  private

  def authenticate_client
    redirect_to root_path, notice: 'Acesso não autorizado' unless current_user.client?
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
