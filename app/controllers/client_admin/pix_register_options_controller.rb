class ClientAdmin::PixRegisterOptionsController < ApplicationController
  require 'csv'
  def new
    @pix_register_option = PixRegisterOption.new
    @payment_option = PaymentOption.find(params[:payment_option_id])
    @bank_codes = BankCode.all
  end

  def create
    @company = current_user.company
    @payment_option = PaymentOption.find(params[:payment_option_id])
    @pix_register_option = @company.pix_register_options.new(pix_register_option_params)
    @pix_register_option.name = @payment_option.name
    if @pix_register_option.save!
      PaymentCompany.create!(company: @company, payment_option: @payment_option)
      redirect_to payment_chosen_client_admin_companies_path, notice: 'Opção adicionada com sucesso'
    else
      byebug
    end
  end

  private
  def pix_register_option_params
    params.require(:pix_register_option).permit(:pix_key, :bank_code_id)
  end
end