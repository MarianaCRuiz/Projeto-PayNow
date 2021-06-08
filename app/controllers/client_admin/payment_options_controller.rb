class ClientAdmin::PaymentOptionsController < ApplicationController
  
  def index
    @company = current_user.company
    @payment_companies = @company.payment_companies
  end
  def edit
    @payment_option = PaymentOption.find(params[:id])
  end
  def update
     @payment_option = PaymentOption.find(params[:id])
    if @payment_option.update(payment_option_params)
      #redirect_to , notice: t('.success')
    else
      render :edit
    end
  end
  
  private
  def payment_option_params
    params.require(:payment_option).permit(:name, :fee, :max_money_fee, :state, :icon)
  end
end
