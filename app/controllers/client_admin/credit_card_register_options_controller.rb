class ClientAdmin::CreditCardRegisterOptionsController < ApplicationController
  def new
    @credit_card_register_option = CreditCardRegisterOption.new
    @payment_option = PaymentOption.find(params[:payment_option_id])
  end
  def create
    @company = current_user.company
    @payment_option = PaymentOption.find(params[:payment_option_id])
    @credit_card_register_option = @company.credit_card_register_options.new(credit_card_register_option_params)
    @credit_card_register_option.name = @payment_option.name
    if @credit_card_register_option.save!
      redirect_to payment_chosen_client_admin_companies_path, notice: 'Opção adicionada com sucesso'
    else
      byebug
    end
  end
  private
  def credit_card_register_option_params
    params.require(:credit_card_register_option).permit(:credit_card_operator_token)
  end
end