class Clients::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_client

  def index
    @company = Company.find_by(token: params[:token])
    @products = Product.where(status: 0)  #order(:name)
  end

  def show
    @company = current_user.company
    @product = Product.find_by(token: params[:token])
  end

  def new
    @company = current_user.company
    @product = Product.new
  end

  def create
    @company = current_user.company
    @product = @company.products.new(product_params)
    if @product.save
      redirect_to clients_company_product_path(@company.token, @product.token), notice: 'Opção adicionada com sucesso'
    else
      render :new
    end
  end

  def edit
    @company = current_user.company
    @product = Product.find_by(token: params[:token])
  end

  def update
    @company = current_user.company
    @product = Product.find_by(token: params[:token])
    if @product.update(product_params)
      redirect_to clients_company_product_path(current_user.company, @product.token), notice: 'Opção atualizada com sucesso'
    else
      render :edit
    end
  end

  def product_status
    @company = current_user.company
    @product = Product.find_by(token: params[:token])
    @product.inactive!
    @product.name = ''
    @product.save!
    redirect_to clients_company_products_path(current_user.company), notice: 'Produto excluído com sucesso'
  end 
  
  private

  def authenticate_client
    redirect_to root_path, notice: 'Acesso não autorizado' unless current_user.client?
  end

  def product_params
    params.require(:product).permit(:name, :price, :boleto_discount, :credit_card_discount, :pix_discount)
  end
end