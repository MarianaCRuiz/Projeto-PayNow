class ClientAdmin::PixRegisterOptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_client_admin
  before_action :bank_code_generate, only: %i[new edit]

  def new
    @pix_register_option = PixRegisterOption.new
    @payment_option = PaymentOption.find(params[:payment_option_id])
    @bank_codes = BankCode.all
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
      redirect_to payments_chosen_client_admin_company_path(@company.token), notice: 'Opção adicionada com sucesso'
    else
      @payment_option = PaymentOption.find(params[:payment_option_id])
      @bank_codes = BankCode.all
      render :new
    end
  end

  def edit 
    @pix_register_option = PixRegisterOption.find(params[:id])
    @payment_option = PaymentOption.find(params[:payment_option_id])
    @bank_codes = BankCode.all
  end

  def update 
    @pix_register_option = PixRegisterOption.find(params[:id])
    if @pix_register_option.update(pix_register_option_params)
      redirect_to payments_chosen_client_admin_company_path(current_user.company.token), notice: 'Opção atualizada com sucesso'
    else
      @payment_option = PaymentOption.find(params[:payment_option_id])
      @bank_codes = BankCode.all
      render :edit
    end
  end

  def exclude 
    @company = current_user.company
    @pix = PixRegisterOption.find(params[:id])
    @payment_option = @pix.payment_option
    @pix.pix_key = ''
    @pix.inactive!
    if @pix.save
      @company.payment_companies.find_by(payment_option: @payment_option).destroy
      redirect_to payments_chosen_client_admin_company_path(@company.token), notice: 'Meio de pagamento excluído com sucesso'
    else
      redirect_to payments_chosen_client_admin_companies_path, notice: 'Não foi possível excluir'
    end
  end 

  private

  def authenticate_client_admin
    redirect_to root_path, notice: 'Acesso não autorizado' unless current_user.client_admin? || current_user.client_admin_sign_up? 
  end

  def pix_register_option_params
    params.require(:pix_register_option).permit(:pix_key, :bank_code_id)
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