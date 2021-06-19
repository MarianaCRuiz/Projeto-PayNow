class ClientAdmin::BoletoRegisterOptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :bank_code_generate, only: %i[new edit]
  
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
    if current_user.client_admin? || current_user.client_admin_sign_up? 
      @company = current_user.company
      @payment_option = PaymentOption.find(params[:payment_option_id])
      @boleto_register_option = @company.boleto_register_options.new(boleto_register_option_params)
      @boleto_register_option.payment_option = @payment_option
      @boleto_register_option.name = @payment_option.name
      @boleto_register_option.fee = @payment_option.fee
      @boleto_register_option.max_money_fee = @payment_option.max_money_fee
      if @boleto_register_option.save
        PaymentCompany.create!(company: @company, payment_option: @payment_option)
        redirect_to payments_chosen_client_admin_company_path(@company.token), notice: 'Opção adicionada com sucesso'
      else
        @payment_option = PaymentOption.find(params[:payment_option_id])
        @bank_codes = BankCode.all
        render :new
      end
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def edit
    if current_user.client_admin? || current_user.client_admin_sign_up? 
      @boleto_register_option = BoletoRegisterOption.find(params[:id])
      @payment_option = PaymentOption.find(params[:payment_option_id])
      @bank_codes = BankCode.all
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def update
    if current_user.client_admin? || current_user.client_admin_sign_up? 
      @boleto_register_option = BoletoRegisterOption.find(params[:id])
      if @boleto_register_option.update(boleto_register_option_params)
        redirect_to payments_chosen_client_admin_company_path(current_user.company.token), notice: 'Opção atualizada com sucesso'
      else
        @payment_option = PaymentOption.find(params[:payment_option_id])
        @bank_codes = BankCode.all
        render :edit
      end
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def exclude
    if current_user.client_admin? || current_user.client_admin_sign_up? 
      @company = current_user.company
      @boleto = BoletoRegisterOption.find(params[:id])
      @payment_option = @boleto.payment_option
      @boleto.agency_number = ''
      @boleto.account_number = ''
      @boleto.inactive!
      if @boleto.save
        @company.payment_companies.find_by(payment_option: @payment_option).destroy
        redirect_to payments_chosen_client_admin_company_path(@company.token), notice: 'Meio de pagamento excluído com sucesso'
      else
        redirect_to payments_chosen_client_admin_company_path(@company.token), notice: 'Não foi possível excluir'
      end
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end 

  private

  def boleto_register_option_params
    params.require(:boleto_register_option).permit(:bank_code_id, :agency_number, :account_number)
  end
  def bank_code_generate
    require 'csv'
    if BankCode.count < 99
      csv_text = File.read("#{Rails.root}/public/bank_codes3.csv")
      csv = CSV.parse(csv_text, :headers => true)
      csv.each do |row|
        code, bank = row.to_s.split(' ', 2)
        BankCode.create(code: code, bank: bank)
      end
    end
  end
end