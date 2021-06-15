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
    @company = current_user.company
    @boletos = @company.boleto_register_options
    @credit_cards = @company.credit_card_register_options
    @pixies = @company.pix_register_options
    @payments_chosen = @company.payment_options
  end
end