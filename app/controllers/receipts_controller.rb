class ReceiptsController < ApplicationController
  
  def index
    if params[:receipt_filter]
      @filter = ReceiptFilter.find(params[:receipt_filter])
      @receipt = Receipt.find_by(authorization_token: @filter.token)
      @filter.destroy
      if !@receipt then flash[:notice] = 'Nenhum recibo encontrado' end
    end
  end
  
  def filter  #kdmwemd2127
    @filter = ReceiptFilter.new(token: params[:token])
    @filter.save
    redirect_to receipts_path(receipt_filter: @filter)
  end

end