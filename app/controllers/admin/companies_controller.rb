class Admin::CompaniesController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      @companies = Company.all
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  def show
    if current_user.admin?
      @company = Company.find_by(token: params[:token])
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  
  def edit
    if current_user.admin? 
      @company = Company.find_by(token: params[:token])
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def update
    if current_user.admin?
      @company = Company.find_by(token: params[:token])
      if @company.update(company_params)
        @historic = HistoricCompany.new(company_params)
        @historic.company = @company
        @historic.token = @company.token
        @historic.save
        redirect_to admin_company_path(@company[:token])
      else
        render :edit
      end
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def token_new
    if current_user.admin?
      @company = Company.find_by(token: params[:token])
      token = SecureRandom.base58(20)
      same = true
      while same == true do
        if Company.where(token: token).empty?
          @company.token = token
          same = false
        else
          @company.token = SecureRandom.base58(20)
        end
      end
      if @company.save
        @historic = HistoricCompany.new(corporate_name: @company.corporate_name, cnpj: @company.cnpj, 
                                        state: @company.state, city: @company.city, 
                                        district: @company.district, street: @company.street, 
                                        number: @company.number, address_complement: @company.address_complement, 
                                        billing_email: @company.billing_email, token: @company.token, 
                                        company: @company)
        @historic.save!
        redirect_to client_admin_company_path(@company[:token])
      else
        redirect_to client_admin_company_path(@company[:token]), notice: 'Falha ao gerar o token novo'
      end
      else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  private
  def company_params
    params.require(:company).permit(:corporate_name, :cnpj, :state, :city, :district, :street, :number, :address_complement, :billing_email)
  end

end