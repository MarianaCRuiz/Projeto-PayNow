class Admin::PaymentOptionsController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.admin?
      @payment_options = PaymentOption.all
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  def new
    if current_user.admin?
      @payment_option = PaymentOption.new
      @payments = PaymentOption.all
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  def create
    if current_user.admin?
      @payment_option = PaymentOption.new(payment_option_params)
      if @payment_option.save
        redirect_to admin_payment_options_path(@payment_option)
      else
        @payments = PaymentOption.all
        render :new
      end
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  def edit
    if current_user.admin? 
      @payment_option = PaymentOption.find(params[:id])
      @payments = PaymentOption.all
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def update
    if current_user.admin?
      @payment_option = PaymentOption.find(params[:id])
      if 
        @payment_option.update(payment_option_params)
        redirect_to admin_payment_options_path(@payment_option)
      else
        @payments = PaymentOption.all
        render :edit
      end
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  
  private
  def payment_option_params
    params.require(:payment_option).permit(:name, :fee, :max_money_fee, :state, :icon, :state, :type)
  end
end
