class Admin::CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin

  def index
    @block_company_1 = BlockCompany.find_by(email_1: current_user.email)
    @block_company_2 = BlockCompany.find_by(email_2: current_user.email)
    @companies = Company.all
  end
  def show
    @company = Company.find_by(token: params[:token])
    @companies = Company.all
  end
  
  def edit 
    @company = Company.find_by(token: params[:token])
  end

  def update
    @company = Company.find_by(token: params[:token])
    if @company.update(company_params)
      redirect_to admin_company_path(@company[:token])
    else
      render :edit
    end
  end

  def token_new
    @company = Company.find_by(token: params[:token])
    @company.generate_token
    if @company.save
      redirect_to client_admin_company_path(@company[:token])
    else
      redirect_to client_admin_company_path(@company[:token]), notice: 'Falha ao gerar o token novo'
    end
  end

  def emails
    @company = Company.find_by(token: params[:token])
    @domains = DomainRecord.all
    @emails = @company.domain_records
  end
  
  def block_email
    @company = Company.find_by(token: params[:token])
    if params[:email]
      @email = @company.domain_records.find_by(email: params[:email])
    elsif params[:email_client_admin]
      @email = @company.domain_records.find_by(email_client_admin: params[:email_client_admin])
    end
    @email.blocked!
    redirect_to emails_admin_company_path(@company.token), notice: 'Email bloqueado com sucesso'
  end

  def unblock_email
    @company = Company.find_by(token: params[:token])
    if params[:email]
      @email = @company.domain_records.find_by(email: params[:email])
    elsif params[:email_client_admin]
      @email = @company.domain_records.find_by(email_client_admin: params[:email_client_admin])
    end
    @email.allowed!
    redirect_to emails_admin_company_path(@company.token), notice: 'Email desbloqueado com sucesso'
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
      @company.blocked!
      DomainRecord.where(company: @company).each do |user|
        if user.email then user.blocked!
        elsif user.email_client_admin then user.blocked!
        end
      end
    end
    redirect_to admin_company_path(@company.token)
  end

  private

  def authenticate_admin
    redirect_to root_path, notice: 'Acesso não autorizado' unless current_user.admin?
  end

  def company_params
    params.require(:company).permit(:corporate_name, :cnpj, :state, :city, :district, :street, :number, :address_complement, :billing_email)
  end

end