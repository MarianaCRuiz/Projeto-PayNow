class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  #rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  

  private
  
  def not_found  #para consulta de cobranças
    head 404
  end
  
  #def record_invalid(exception)
  #  byebug
  #  render json: exception.record.errors, status: :unprocessable_entity   #? ou precondition_failed
  #end
end