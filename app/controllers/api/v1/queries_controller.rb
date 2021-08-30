class Api::V1::QueriesController < ActionController::API
  before_action :find_company_payment

  def consult_charges
    analysing_deadlines
    if @due_deadline_max && @due_deadline_min && @due_deadline_max < @due_deadline_min
      head :range_not_satisfiable
    elsif !@charges.empty?
      render json: @charges
    elsif @payment_method && @company.payment_options.where(name: @payment_method).empty?
      head :not_found
    else
      render json: @charges, status: :no_content
    end
  end

  private

  def consult_params
    params.require(:consult).permit(:payment_method, :due_deadline, :due_deadline_min, :due_deadline_max)
  end

  def find_company_payment
    @company = Company.find_by(token: params[:company_token])
    @payment_method = consult_params[:payment_method]
    @due_deadline = consult_params[:due_deadline]
    @due_deadline_max = consult_params[:due_deadline_max]
    @due_deadline_min = consult_params[:due_deadline_min]
    @charges = @company.charges.where(payment_method: @payment_method) if @payment_method
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end

  def analysing_deadlines
    specific_deadline?
    max_deadline?
    min_deadline?
    interval_deadline?
    no_deadline?
  end

  def specific_deadline?
    return unless @due_deadline

    @charges = if @payment_method
                 @charges.where(due_deadline: @due_deadline)
               else
                 @company.charges.where(due_deadline: @due_deadline)
               end
  end

  def max_deadline?
    return unless @due_deadline_max && !@due_deadline_min

    @charges = if @payment_method
                 @charges.where('due_deadline <= ?', @due_deadline_max.to_date.strftime('%Y-%m-%d'))
               else
                 @company.charges.where('due_deadline <= ?', @due_deadline_max.to_date.strftime('%Y-%m-%d'))
               end
  end

  def min_deadline?
    return unless @due_deadline_min && !@due_deadline_max

    @charges = if @payment_method
                 @charges.where('due_deadline >= ?', @due_deadline_min.to_date.strftime('%Y-%m-%d'))
               else
                 @company.charges.where('due_deadline >= ?', @due_deadline_min.to_date.strftime('%Y-%m-%d'))
               end
  end

  def interval_deadline?
    return unless @due_deadline_max && @due_deadline_min

    @charges = if @payment_method
                 @charges.where('due_deadline <= ? and due_deadline >= ?',
                                @due_deadline_max.to_date.strftime('%Y-%m-%d'),
                                @due_deadline_min.to_date.strftime('%Y-%m-%d'))
               else
                 @company.charges.where('due_deadline <= ? and due_deadline >= ?',
                                        @due_deadline_max.to_date.strftime('%Y-%m-%d'),
                                        @due_deadline_min.to_date.strftime('%Y-%m-%d'))
               end
  end

  def no_deadline?
    @charges = @company.charges if !@due_deadline_max && !@due_deadline_min && !@due_deadline && !@payment_method
  end
end
