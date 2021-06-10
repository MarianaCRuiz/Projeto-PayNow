class ClientAdmin::BoletoRegisterOptionsController < ApplicationController
  def new
    @boleto_register_option = BoletoRegisterOption.new
    @payment_option = PaymentOption.find(params[:payment_option_id])
    @bank_codes = BankCode.all
  end

  def create
    @company = current_user.company
    @payment_option = PaymentOption.find(params[:payment_option_id])
    @boleto_register_option = @company.boleto_register_options.new(boleto_register_option_params)
    @boleto_register_option.name = @payment_option.name
    if @boleto_register_option.save!
      redirect_to payment_chosen_client_admin_companies_path, notice: 'Opção adicionada com sucesso'
    else
      byebug
    end
  end

  private
  def boleto_register_option_params
    params.require(:boleto_register_option).permit(:bank_code_id, :agency_number, :account_number)
  end
end