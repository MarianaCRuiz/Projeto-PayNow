class Api::V1::TokensController < ActionController::API

  def final_clients
    @company = Company.find_by(token: params[:token])
    @final_client = FinalClient.new(final_client_params)
    if @final_client.save
      @company.company_clients.create!(final_client: @final_client)
      render json: @final_client, status: 201
    else
      head 400
    end
  end
  
  private
  def final_client_params
    params.require(:final_client).permit(:name, :cpf)
  end
end