class Api::V1::FinalClientsController < ActionController::API
  before_action :find_contents

  def final_client_token
    @final_client.save!
    @company.company_clients.create!(final_client: @final_client)
    render json: @final_client, status: :created
  rescue ActiveRecord::RecordInvalid
    testing_company
  end

  private

  def final_client_params
    params.require(:final_client).permit(:name, :cpf)
  end

  def find_contents
    @same = false
    @final_client = FinalClient.new(final_client_params)
    @company = Company.find_by(token: params[:company_token])
    @client = FinalClient.where(cpf: @final_client.cpf).first
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end

  def testing_company
    same_company?
    different_company?
    case @same
    when false
      render json: FinalClient.find_by(cpf: @client.cpf), status: :accepted
    when true
      render json: @final_client.errors, status: :conflict
    end
  end

  def same_company?
    @same = true if @client && !CompanyClient.where(company: @company, final_client: @client).empty?
  end

  def different_company?
    if @client && CompanyClient.where(company: @company,
                                      final_client: @client).empty? && !FinalClient.where(cpf: @client.cpf).empty?
      @final_client = FinalClient.find_by(cpf: @client.cpf)
      @company_client = @company.company_clients.create!(final_client: @client)
      @same = false
    end
  end
end
