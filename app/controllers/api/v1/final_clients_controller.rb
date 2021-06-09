class Api::V1::FinalClientsController < ActionController::API

  #def index
  #  @final_clients = FinalClient.all
  #  render json: @final_clients
  #end
  def show
    @final_client = FinalClient.find_by(token: params[:token])
    render json: @final_client
  end
end