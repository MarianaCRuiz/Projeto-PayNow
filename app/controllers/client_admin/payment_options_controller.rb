class ClientAdmin::PaymentOptionsController < ApplicationController
  
  def index
    @payment_options = PaymentOption.all
  end
  #def new
  #  @payment_option = PaymentOption.new
  #end
  #def create
   # byebug
    #@company = Company.new(company_params)
    #if @company.save!
    #  DomainRecord.where(email_client_admin: current_user.email).first.company_id = @company.id
    #  current_user.company = @company
    #  redirect_to client_admin_company_path(@company[:token])
    #else
    #  redirect_to root_path, notice: 'erro'
    #end
  #end
  
  #private
  #def payment_option_params
  #  params.require(:payment_option).permit(:name, :fee, :max_money_fee, :state, :icon)
  #end
end
