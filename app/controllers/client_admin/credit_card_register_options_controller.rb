class ClientAdmin::CreditCardRegisterOptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_client_admin

  def new
    @credit_card_register_option = CreditCardRegisterOption.new
    @payment_option = PaymentOption.find(params[:payment_option_id])
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
      redirect_to payments_chosen_client_admin_company_path(@company.token), notice: 'Opção adicionada com sucesso'
    else
      render :new
    end
  end

  def edit 
    @credit_card_register_option = CreditCardRegisterOption.find(params[:id])
    @payment_option = PaymentOption.find(params[:payment_option_id])
    @bank_codes = BankCode.all
  end

  def update 
    @credit_card_register_option = CreditCardRegisterOption.find(params[:id])
    if @credit_card_register_option.update(credit_card_register_option_params)
      redirect_to payments_chosen_client_admin_company_path(current_user.company.token), notice: 'Opção atualizada com sucesso'
    else
      @payment_option = PaymentOption.find(params[:payment_option_id])
      @bank_codes = BankCode.all
      render :edit
    end
  end

  def exclude 
    @company = current_user.company
    @creditcard = CreditCardRegisterOption.find(params[:id])
    @payment_option = @creditcard.payment_option
    @creditcard.credit_card_operator_token = ''
    @creditcard.inactive!
    if @creditcard.save
      @company.payment_companies.find_by(payment_option: @payment_option).destroy
      redirect_to payments_chosen_client_admin_company_path(@company.token), notice: 'Meio de pagamento excluído com sucesso'
    else
      redirect_to payments_chosen_client_admin_company_path(@company.token), notice: 'Não foi possível excluir'
    end
  end 
  
  private
  
  def authenticate_client_admin
    redirect_to root_path, notice: 'Acesso não autorizado' unless current_user.client_admin? || current_user.client_admin_sign_up? 
  end

  def credit_card_register_option_params
    params.require(:credit_card_register_option).permit(:credit_card_operator_token)
  end
end