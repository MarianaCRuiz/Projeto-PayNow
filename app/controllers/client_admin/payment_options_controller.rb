class ClientAdmin::PaymentOptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_client_admin

  def index
    @company = current_user.company
    @payment_options = PaymentOption.order(:name)
  end

  private

  def authenticate_client_admin
    unless current_user.client_admin? || current_user.client_admin_sign_up?
      redirect_to root_path,
                  notice: 'Acesso não autorizado'
    end
  end
end
