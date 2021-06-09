class ClientAdmin::PaymentOptionsController < ApplicationController
  
  def index
    @payment_options = PaymentOption.order(:name)  #all
  end
 
end
