class ClientAdmin::CompaniesController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user.client_admin? || current_user.client_admin_sign_up?
      @company = Company.find_by(token: params[:token])
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  def new
    @company = Company.new
  end
  def create
    @company = Company.new(company_params)
    if @company.save
      DomainRecord.where(email_client_admin: current_user.email).first.company_id = @company.id
      current_user.company = @company
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
      redirect_to client_admin_company_path(@company[:token])
    else
      render :edit
    end
  end

  def payment_chosen #get
    @company = current_user.company
    @boletos = @company.boleto_register_options
    @credit_cards = @company.credit_card_register_options
    @pixies = @company.pix_register_options
    @payments_chosen = @company.payment_companies
  end

  private
  def company_params
    params.require(:company).permit(:corporate_name, :cnpj, :state, :city, :district, :street, :number, :address_complement, :billing_email, :token)
  end

end