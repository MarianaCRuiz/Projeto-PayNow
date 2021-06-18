class Clients::CompaniesController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user.client?
      @company = Company.find_by(token: params[:token])
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  def payments_chosen #get
    if current_user.client?
      @company = current_user.company
      @boletos = @company.boleto_register_options.where(status: 0)
      @credit_cards = @company.credit_card_register_options.where(status: 0)
      @pixes = @company.pix_register_options.where(status: 0)
      @payments_chosen = @company.payment_options.where(state: 0)
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
end