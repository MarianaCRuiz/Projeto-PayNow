class ClientAdmin::CompaniesController < ApplicationController
  
  def show
    @company = Company.find_by(token: params[:token])
  end
  def new
    @company = Company.new
  end
  def create
    @company = Company.new(company_params)
    if @company.save!
      redirect_to client_admin_company_path(@company[:token])
    else
      redirect_to root_path, notice: 'erro'
    end
  end

  private
  def company_params
    params.require(:company).permit(:corporate_name, :cnpj, :state, :city, :district, :street, :number, :address_complement, :billing_email)
  end
end