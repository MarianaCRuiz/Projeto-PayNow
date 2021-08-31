class Admin::CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :find_company
  before_action :find_email, only: %i[block_email unblock_email]

  def index
    @block_company1 = BlockCompany.find_by(email1: current_user.email)
    @block_company2 = BlockCompany.find_by(email2: current_user.email)
    @companies = Company.all
  end

  def show
    @companies = Company.all
  end

  def edit; end

  def update
    if @company.update(company_params)
      redirect_to admin_company_path(@company[:token])
    else
      render :edit
    end
  end

  def token_new
    @company.generate_token
    @company.save
    redirect_to client_admin_company_path(@company[:token])
  end

  def emails
    @domains = DomainRecord.all
    @emails = @company.domain_records
  end

  def block_email
    @email.blocked!
    redirect_to emails_admin_company_path(@company.token), notice: 'Email bloqueado com sucesso'
  end

  def unblock_email
    @email.allowed!
    redirect_to emails_admin_company_path(@company.token), notice: 'Email desbloqueado com sucesso'
  end

  def block_company
    @block = BlockCompany.find_by(company: @company)
    @block ||= BlockCompany.create(company: @company, email1: current_user.email)
    check_votes
    redirect_to admin_company_path(@company.token)
  end

  private

  def authenticate_admin
    redirect_to root_path, notice: 'Acesso não autorizado' unless current_user.admin?
  end

  def company_params
    params.require(:company).permit(:corporate_name, :cnpj, :state, :city, :district, :street, :number,
                                    :address_complement, :billing_email)
  end

  def find_company
    @company = Company.find_by(token: params[:token])
  end

  def find_email
    if params[:email]
      @email = @company.domain_records.find_by(email: params[:email])
    elsif params[:email_client_admin]
      @email = @company.domain_records.find_by(email_client_admin: params[:email_client_admin])
    end
  end

  def check_votes
    if @block.vote1
      @block.vote1 = false
      @block.save
    elsif @block.vote2 && @block.email1 != current_user.email
      @block.vote2 = false
      @block.email2 = current_user.email
      @block.save
    end
    block_company?
  end

  def block_company?
    return unless @block.vote1 == false && @block.vote2 == false

    @company.blocked!
    DomainRecord.where(company: @company).each do |user|
      user.blocked! if user.email || user.email_client_admin
    end
  end
end
