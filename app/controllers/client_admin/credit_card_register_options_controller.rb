class ClientAdmin::CreditCardRegisterOptionsController < ApplicationController
  before_action :authenticate_user!
  def new
    if current_user.client_admin? || current_user.client_admin_sign_up?
      @credit_card_register_option = CreditCardRegisterOption.new
      @payment_option = PaymentOption.find(params[:payment_option_id])
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  def create
    @company = current_user.company
    @payment_option = PaymentOption.find(params[:payment_option_id])
    @credit_card_register_option = @company.credit_card_register_options.new(credit_card_register_option_params)
    @credit_card_register_option.payment_option = @payment_option
    @credit_card_register_option.name = @payment_option.name
    @credit_card_register_option.fee = @payment_option.fee
    @credit_card_register_option.max_money_fee = @payment_option.max_money_fee
    if @credit_card_register_option.save
      PaymentCompany.create!(company: @company, payment_option: @payment_option)
      redirect_to payment_chosen_client_admin_companies_path, notice: 'Opção adicionada com sucesso'
    else
      render :new
    end
  end
  private
  def credit_card_register_option_params
    params.require(:credit_card_register_option).permit(:credit_card_operator_token)
  end
end