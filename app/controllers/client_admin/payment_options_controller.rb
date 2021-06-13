class ClientAdmin::PaymentOptionsController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.client_admin? || current_user.client_admin_sign_up?
      @company = current_user.company
      @payment_options = PaymentOption.order(:name)
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
end