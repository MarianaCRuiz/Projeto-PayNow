class Api::V1::FinalClientsController < ActionController::API
  
  def final_client_token
    @final_client = FinalClient.new(final_client_params)
    @company = Company.find_by(token: params[:company_token])
    @final_client.save!
    @company.company_clients.create!(final_client: @final_client)
    render json: @final_client, status: 201
  rescue ActiveRecord::RecordInvalid                       #ActionController::ParameterMissing
    @client = FinalClient.where(cpf: @final_client.cpf).first
    if @client && CompanyClient.where(company: @company, final_client: @client).empty? && !FinalClient.where(cpf: @client.cpf).empty?
      @final_client = FinalClient.find_by(cpf: @client.cpf)
      @company_client = @company.company_clients.create!(final_client: @client)
      render json: FinalClient.find_by(cpf: @client.cpf), status: 202
    elsif @client && !CompanyClient.where(company: @company, final_client: @client).empty?
      render json: @final_client.errors, status: 409
    else
      render json: @final_client.errors, status: :precondition_failed
    end
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end

  private

  def final_client_params
    params.require(:final_client).permit(:name, :cpf)
  end
  
end