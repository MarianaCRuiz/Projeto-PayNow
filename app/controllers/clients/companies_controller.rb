class Clients::CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_client

  def show
    @company = Company.find_by(token: params[:token])
  end

  def payments_chosen
    @company = current_user.company
    @boletos = @company.boleto_register_options.where(status: 0)
    @credit_cards = @company.credit_card_register_options.where(status: 0)
    @pixes = @company.pix_register_options.where(status: 0)
    @payments_chosen = @company.payment_options.where(state: 0)
  end

  private

  def authenticate_client
    redirect_to root_path, notice: 'Acesso não autorizado' unless current_user.client?
  end
end
