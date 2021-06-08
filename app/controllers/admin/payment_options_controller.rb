class Admin::PaymentOptionsController < ApplicationController
  
  def index
    @payment_options = PaymentOption.all
  end
  def new
    @payment_option = PaymentOption.new
  end
  def create
     @payment_option = PaymentOption.new(payment_option_params)
    if @payment_option.save!
        redirect_to admin_payment_options_path(@payment_option)
    else
      redirect_to root_path, notice: 'erro'
    end
  end
  
  private
  def payment_option_params
    params.require(:payment_option).permit(:name, :fee, :max_money_fee, :state, :icon)
  end
end
