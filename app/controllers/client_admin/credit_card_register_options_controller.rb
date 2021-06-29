class ClientAdmin::CreditCardRegisterOptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_client_admin
  before_action :find_payment_option
  before_action :find_company
  before_action :find_credit_card, only: %i[edit update exclude]

  def new
    @credit_card = CreditCardRegisterOption.new
  end

  def create 
    @credit_card = @company.credit_card_register_options.new(credit_card_params)
    save_data
    if @credit_card.save
      PaymentCompany.create!(company: @company, payment_option: @payment_option)
      redirect_to payments_chosen_client_admin_company_path(@company.token), notice: 'Opção adicionada com sucesso'
    else
      render :new
    end
  end

  def edit 
    @bank_codes = BankCode.all
  end

  def update 
    if @credit_card.update(credit_card_params)
      redirect_to payments_chosen_client_admin_company_path(current_user.company.token), notice: 'Opção atualizada com sucesso'
    else
      @bank_codes = BankCode.all
      render :edit
    end
  end

  def exclude     
    @payment_option = @credit_card.payment_option
    @credit_card.credit_card_operator_token = ''
    @credit_card.inactive!
    if @credit_card.save
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

  def credit_card_params
    params.require(:credit_card_register_option).permit(:credit_card_operator_token)
  end

  def find_payment_option
    @payment_option = PaymentOption.find(params[:payment_option_id])
  end

  def find_company
    @company = current_user.company
  end

  def find_credit_card
    @credit_card = CreditCardRegisterOption.find(params[:id])
  end

  def save_data
    @credit_card.payment_option = @payment_option
    @credit_card.name = @payment_option.name
    @credit_card.fee = @payment_option.fee
    @credit_card.max_money_fee = @payment_option.max_money_fee
  end
end