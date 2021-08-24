class Api::V1::FinalClientsController < ActionController::API
  def final_client_token
    @same = false
    @final_client = FinalClient.new(final_client_params)
    @company = Company.find_by(token: params[:company_token])
    @final_client.save!
    @company.company_clients.create!(final_client: @final_client)
    render json: @final_client, status: :created
  rescue ActiveRecord::RecordInvalid
    @client = FinalClient.where(cpf: @final_client.cpf).first
    same_company?
    different_company?
    if @same == false
      render json: FinalClient.find_by(cpf: @client.cpf), status: :accepted
    elsif @same == true
      render json: @final_client.errors, status: :conflict
    end
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end

  private

  def final_client_params
    params.require(:final_client).permit(:name, :cpf)
  end

  def different_company?
    if @client && CompanyClient.where(company: @company,
                                      final_client: @client).empty? && !FinalClient.where(cpf: @client.cpf).empty?
      @final_client = FinalClient.find_by(cpf: @client.cpf)
      @company_client = @company.company_clients.create!(final_client: @client)
      @same = false
    end
  end

  def same_company?
    @same = true if @client && !CompanyClient.where(company: @company, final_client: @client).empty?
  end
end
