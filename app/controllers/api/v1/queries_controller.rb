class Api::V1::QueriesController < ActionController::API
  before_action :status_charge_generate
  
  def consult_charges
    @company = Company.find_by(token: params[:company_token])
    @payment_method = consult_params[:payment_method]
    if @payment_method then @charges = @company.charges.where(payment_method: @payment_method) end
    find_deadlines
    specifc_deadline?
    max_deadline?
    min_deadline?
    interval_deadline? 
    no_deadline?
    if @due_deadline_max && @due_deadline_min && @due_deadline_max < @due_deadline_min
      head 416
    else
      if !@charges.empty?
        render json: @charges
      elsif @payment_method && @company.payment_options.where(name: @payment_method).empty?
        head 404
      else
        render json: @charges, status: 204
      end
    end
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: { errors: 'parâmetros inválidos' }
  end

  private
  
  def consult_params
    params.require(:consult).permit(:payment_method, :due_deadline, :due_deadline_min, :due_deadline_max)
  end

  def find_deadlines
    @due_deadline = consult_params[:due_deadline]
    @due_deadline_max = consult_params[:due_deadline_max]
    @due_deadline_min = consult_params[:due_deadline_min]
  end

  def specifc_deadline?
    if @due_deadline
      if !@payment_method 
        @charges = @company.charges.where(due_deadline: @due_deadline)
      else
        @charges = @charges.where(due_deadline: @due_deadline)
      end
    end
  end

  def max_deadline?
    if @due_deadline_max && !@due_deadline_min
      if !@payment_method
        @charges = @company.charges.where("due_deadline <= ?", @due_deadline_max.to_date.strftime("%Y-%m-%d"))
      else
        @charges = @charges.where("due_deadline <= ?", @due_deadline_max.to_date.strftime("%Y-%m-%d"))
      end
    end
  end

  def min_deadline?
    if @due_deadline_min && !@due_deadline_max
      if !@payment_method
        @charges = @company.charges.where("due_deadline >= ?", @due_deadline_min.to_date.strftime("%Y-%m-%d")) 
      else
        @charges = @charges.where("due_deadline >= ?", @due_deadline_min.to_date.strftime("%Y-%m-%d"))
      end
    end
  end
    
  def interval_deadline?
    if @due_deadline_max && @due_deadline_min
      if !@payment_method
        @charges = @company.charges.where("due_deadline <= ? and due_deadline >= ?", @due_deadline_max.to_date.strftime("%Y-%m-%d"), @due_deadline_min.to_date.strftime("%Y-%m-%d"))
      else
        @charges = @charges.where("due_deadline <= ? and due_deadline >= ?", @due_deadline_max.to_date.strftime("%Y-%m-%d"), @due_deadline_min.to_date.strftime("%Y-%m-%d"))
      end
    end
  end

  def no_deadline?
    if !@due_deadline_max && !@due_deadline_min && !@due_deadline
      if !@payment_method
        @charges = @company.charges
      end
    end
  end

  def status_charge_generate
    require 'csv'
    if StatusCharge.count < 5
      csv_text = File.read("#{Rails.root}/db/csv_folder/charge_status_options.csv")
      csv2 = CSV.parse(csv_text, :headers => true)
      csv2.each do |row|
        code, description = row.to_s.split(' ', 2)
        status = StatusCharge.create(code: code, description: description)
      end
    end
  end
end