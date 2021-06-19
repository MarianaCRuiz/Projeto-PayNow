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

  def block_company
    @company = Company.find_by(token: params[:token])
    @block = BlockCompany.find_by(company: @company)
    if !@block
      @block = BlockCompany.create(company: @company, email_1: current_user.email)
    end
    if @block.vote_1 
      @block.vote_1 = false
      @block.save
    elsif @block.vote_2 && @block.email_1 != current_user.email
      @block.vote_2 = false
      @block.email_2 = current_user.email
      @block.save
    end
    if @block.vote_1 == false && @block.vote_2 == false
  
      DomainRecord.where(company: @company).each do |user|
        if user.email then user.blocked!
        elsif user.email_client_admin then user.blocked!
        end
      end
    end
    redirect_to admin_company_path(@company.token)
  end

  private
  def company_params
    params.require(:company).permit(:corporate_name, :cnpj, :state, :city, :district, :street, :number, :address_complement, :billing_email)
  end

end