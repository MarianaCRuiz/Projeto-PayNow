class ClientAdmin::CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_client_admin

  def show
    @company = Company.find_by(token: params[:token])
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      @historic = HistoricCompany.new(company_params)
      @historic.company = @company
      @historic.token = @company.token
      @historic.save
      DomainRecord.where(email_client_admin: current_user.email).first.company_id = @company.id
      current_user.company = @company
      current_user.save
      redirect_to client_admin_company_path(@company[:token])     
    else
      render :new
    end
  end

  def edit 
    @company = Company.find_by(token: params[:token])
  end

  def update
    @company = Company.find_by(token: params[:token])
    if @company.update(company_params)
      @historic = HistoricCompany.new(company_params)
      @historic.company = @company
      @historic.token = @company.token
      @historic.save
      redirect_to client_admin_company_path(@company[:token])
    else
      render :edit
    end
  end

  def payments_chosen
    @company = current_user.company
    @boletos = @company.boleto_register_options.where(status: 0)
    @credit_cards = @company.credit_card_register_options.where(status: 0)
    @pixes = @company.pix_register_options.where(status: 0)
    @payments_chosen = @company.payment_options.where(state: 0)
  end

  def emails
    @company = current_user.company
    @domains = DomainRecord.all
    @emails = @company.domain_records
  end

  def block_email
    @company = current_user.company
    @email = @company.domain_records.find_by(email: params[:email])
    @email.blocked!
    redirect_to emails_client_admin_company_path(@company.token), notice: 'Email bloqueado com sucesso'
  end

  def unblock_email
    @company = current_user.company
    @email = @company.domain_records.find_by(email: params[:email])
    @email.allowed!
    redirect_to emails_client_admin_company_path(@company.token), notice: 'Email desbloqueado com sucesso'
  end

  def token_new
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
      @historic.save
      redirect_to client_admin_company_path(@company[:token])
    else
      redirect_to client_admin_company_path(@company[:token]), notice: 'Falha ao gerar o token novo'
    end
  end

  private

  def authenticate_client_admin
    redirect_to root_path, notice: 'Acesso não autorizado' unless current_user.client_admin? || current_user.client_admin_sign_up? 
  end

  def company_params
    params.require(:company).permit(:corporate_name, :cnpj, :state, :city, :district, :street, :number, :address_complement, :billing_email)
  end

end