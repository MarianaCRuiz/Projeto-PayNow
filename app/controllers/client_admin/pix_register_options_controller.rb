class ClientAdmin::PixRegisterOptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_client_admin
  before_action :bank_code_generate, only: %i[new edit]
  before_action :find_pix, only: %i[edit update exclude]
  before_action :find_payment, except: %i[exclude]
  before_action :find_bank_code, except: %i[exclude]
  before_action :find_company

  def new
    @pix = PixRegisterOption.new
  end

  def create
    @pix = @company.pix_register_options.new(pix_register_option_params)
    save_data
    if @pix.save
      PaymentCompany.create!(company: @company, payment_option: @payment_option)
      redirect_to payments_chosen_client_admin_company_path(@company.token), notice: 'Opção adicionada com sucesso'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @pix.update(pix_register_option_params)
      redirect_to payments_chosen_client_admin_company_path(current_user.company.token),
                  notice: 'Opção atualizada com sucesso'
    else
      render :edit
    end
  end

  def exclude
    @payment_option = @pix.payment_option
    @pix.pix_key = ''
    @pix.inactive!
    @pix.save!
    @company.payment_companies.find_by(payment_option: @payment_option).destroy
    redirect_to payments_chosen_client_admin_company_path(@company.token),
                notice: 'Meio de pagamento excluído com sucesso'
  end

  private

  def authenticate_client_admin
    return if current_user.client_admin? || current_user.client_admin_sign_up?

    redirect_to root_path, notice: 'Acesso não autorizado'
  end

  def pix_register_option_params
    params.require(:pix_register_option).permit(:pix_key, :bank_code_id)
  end

  def find_pix
    @pix = PixRegisterOption.find(params[:id])
  end

  def find_payment
    @payment_option = PaymentOption.find(params[:payment_option_id])
  end

  def find_bank_code
    @bank_codes = BankCode.all
  end

  def find_company
    @company = current_user.company
  end

  def save_data
    @pix.payment_option = @payment_option
    @pix.name = @payment_option.name
    @pix.fee = @payment_option.fee
    @pix.max_money_fee = @payment_option.max_money_fee
  end

  def bank_code_generate
    require 'csv'
    return unless BankCode.count < 99

    csv_text = File.read(Rails.root.join('db', 'csv_folder', 'charge_status_options.csv'))
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      code, bank = row.to_s.split(' ', 2)
      BankCode.create(code: code, bank: bank)
    end
  end
end
