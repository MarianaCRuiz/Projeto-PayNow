class ClientAdmin::PixRegisterOptionsController < ApplicationController
  before_action :authenticate_user!
  require 'csv'
  def new
    if current_user.client_admin? || current_user.client_admin_sign_up?
      @pix_register_option = PixRegisterOption.new
      @payment_option = PaymentOption.find(params[:payment_option_id])
      @bank_codes = BankCode.all
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def create
    @company = current_user.company
    @payment_option = PaymentOption.find(params[:payment_option_id])
    @pix_register_option = @company.pix_register_options.new(pix_register_option_params)
    @pix_register_option.payment_option = @payment_option
    @pix_register_option.name = @payment_option.name
    @pix_register_option.fee = @payment_option.fee
    @pix_register_option.max_money_fee = @payment_option.max_money_fee
    if @pix_register_option.save
      PaymentCompany.create!(company: @company, payment_option: @payment_option)
      redirect_to payment_chosen_client_admin_companies_path, notice: 'Opção adicionada com sucesso'
    else
      @payment_option = PaymentOption.find(params[:payment_option_id])
      @bank_codes = BankCode.all
      render :new
    end
  end

  private
  def pix_register_option_params
    params.require(:pix_register_option).permit(:pix_key, :bank_code_id)
  end
end