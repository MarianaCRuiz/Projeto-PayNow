class Admin::PaymentOptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin

  def index
    @payment_options = PaymentOption.all
  end

  def new
    @payment_option = PaymentOption.new
    @payments = PaymentOption.all
  end

  def create
    @payment_option = PaymentOption.new(payment_option_params)
    if @payment_option.save
      redirect_to admin_payment_options_path(@payment_option)
    else
      @payments = PaymentOption.all
      render :new
    end
  end

  def edit
    @payment_option = PaymentOption.find(params[:id])
    @payments = PaymentOption.all
  end

  def update
    @payment_option = PaymentOption.find(params[:id])
    if @payment_option.update(payment_option_params)
      redirect_to admin_payment_options_path(@payment_option)
    else
      @payments = PaymentOption.all
      render :edit
    end
  end

  private

  def authenticate_admin
    redirect_to root_path, notice: 'Acesso não autorizado' unless current_user.admin?
  end

  def payment_option_params
    params.require(:payment_option).permit(:name, :fee, :max_money_fee, :state, :icon, :state, :type)
  end
end
