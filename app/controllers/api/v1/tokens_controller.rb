class Api::V1::TokensController < Api::V1::ApiController

  def final_clients
    @company = Company.find_by(token: params[:token])
    @final_client = FinalClient.new(final_client_params)
    @final_client.save!
    @company.company_clients.create!(final_client: @final_client)
    render json: @final_client, status: 201
  rescue ActiveRecord::RecordInvalid                       #ActionController::ParameterMissing
    @client = FinalClient.where(cpf: @final_client.cpf).first

    if @client && CompanyClient.where(company: @company, final_client: @client).empty?
      if !FinalClient.where(cpf: @client.cpf).empty?
        @final_client = FinalClient.where(cpf: @client.cpf).first
        @company_client = @company.company_clients.create!(final_client: @client)
        render json: FinalClient.where(cpf: @client.cpf).first, status: 202
      end
    else
      render json: @final_client.errors, status: :precondition_failed
    end
  end
  
  private
  def final_client_params
    params.require(:final_client).permit(:name, :cpf)
  end
end