class ClientAdmin::BoletoRegisterOptionsController < ApplicationController
  before_action :authenticate_user!
  def new
    if current_user.client_admin? || current_user.client_admin_sign_up?
      @boleto_register_option = BoletoRegisterOption.new
      @payment_option = PaymentOption.find(params[:payment_option_id])
      @bank_codes = BankCode.all
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def create
    @company = current_user.company
    @payment_option = PaymentOption.find(params[:payment_option_id])
    @boleto_register_option = @company.boleto_register_options.new(boleto_register_option_params)
    @boleto_register_option.payment_option = @payment_option
    @boleto_register_option.name = @payment_option.name
    @boleto_register_option.fee = @payment_option.fee
    @boleto_register_option.max_money_fee = @payment_option.max_money_fee
    if @boleto_register_option.save
      PaymentCompany.create!(company: @company, payment_option: @payment_option)
      redirect_to payment_chosen_client_admin_companies_path, notice: 'Opção adicionada com sucesso'
    else
      @payment_option = PaymentOption.find(params[:payment_option_id])
      @bank_codes = BankCode.all
      render :new
    end
  end

  def edit
    #if current_user.client_admin? || current_user.client_admin_sign_up? 
      @boleto_register_option = BoletoRegisterOption.find(params[:id])
      @payment_option = PaymentOption.find(params[:payment_option_id])
      @bank_codes = BankCode.all
    #else
    #  redirect_to root_path, notice: 'Acesso não autorizado'
    #end
  end

  def update
    @boleto_register_option = BoletoRegisterOption.find(params[:id])
    if @boleto_register_option.update(boleto_register_option_params)
      redirect_to payment_chosen_client_admin_companies_path, notice: 'Opção atualizada com sucesso'
    else
      @payment_option = PaymentOption.find(params[:payment_option_id])
      @bank_codes = BankCode.all
      render :edit
    end
  end

  private
  def boleto_register_option_params
    params.require(:boleto_register_option).permit(:bank_code_id, :agency_number, :account_number)
  end
end