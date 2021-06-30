class ClientAdmin::BoletoRegisterOptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_client_admin
  before_action :bank_code_generate, only: %i[new edit]
  before_action :find_boleto, only: %i[edit update exclude]
  before_action :payment_option_and_bank, except: %i[exclude]
  before_action :find_company
  
  def new
    @boleto = BoletoRegisterOption.new
  end

  def create 
    @boleto = @company.boleto_register_options.new(boleto_register_option_params)
    save_data
    if @boleto.save
      PaymentCompany.create!(company: @company, payment_option: @payment_option)
      redirect_to payments_chosen_client_admin_company_path(@company.token), notice: 'Opção adicionada com sucesso'
    else
      render :new
    end
  end

  def edit
  end

  def update 
    if @boleto.update(boleto_register_option_params)
      redirect_to payments_chosen_client_admin_company_path(current_user.company.token), notice: 'Opção atualizada com sucesso'
    else
      render :edit
    end
  end

  def exclude 
    @payment_option = @boleto.payment_option
    inactivate
    @boleto.save!
    @company.payment_companies.find_by(payment_option: @payment_option).destroy
    redirect_to payments_chosen_client_admin_company_path(@company.token), notice: 'Meio de pagamento excluído com sucesso'
  end 

  private

  def authenticate_client_admin
    redirect_to root_path, notice: 'Acesso não autorizado' unless current_user.client_admin? || current_user.client_admin_sign_up? 
  end

  def boleto_register_option_params
    params.require(:boleto_register_option).permit(:bank_code_id, :agency_number, :account_number)
  end

  def find_boleto
    @boleto = BoletoRegisterOption.find(params[:id])
  end

  def payment_option_and_bank
    @payment_option = PaymentOption.find(params[:payment_option_id])
    @bank_codes = BankCode.all
  end

  def find_company
    @company = current_user.company
  end

  def save_data
    @boleto.payment_option = @payment_option
    @boleto.name = @payment_option.name
    @boleto.fee = @payment_option.fee
    @boleto.max_money_fee = @payment_option.max_money_fee
  end

  def inactivate
    @boleto.agency_number = ''
    @boleto.account_number = ''
    @boleto.inactive!
  end

  def bank_code_generate
    require 'csv'
    if BankCode.count < 99
      csv_text = File.read("#{Rails.root}/db/csv_folder/bank_codes3.csv")
      csv = CSV.parse(csv_text, :headers => true)
      csv.each do |row|
        code, bank = row.to_s.split(' ', 2)
        BankCode.create(code: code, bank: bank)
      end
    end
  end
end