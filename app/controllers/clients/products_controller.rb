class Clients::ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.client?
      @company = Company.find_by(token: params[:token])
      @products = Product.where(status: 0)  #order(:name)
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def show
    if current_user.client?
      @company = current_user.company
      @product = Product.find_by(token: params[:token])
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  def new
    if current_user.client?
      @company = current_user.company
      @product = Product.new
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  def create
    if current_user.client?
      @company = current_user.company
      @product = @company.products.new(product_params)
      if @product.save
        HistoricProduct.create!(product: @product, company: @company, price: @product.price)
        redirect_to clients_company_product_path(@company.token, @product.token), notice: 'Opção adicionada com sucesso'
      else
        render :new
      end
    else
      redirect_to root_path
    end
  end
  def edit
    if current_user.client?
      @company = current_user.company
      @product = Product.find_by(token: params[:token])
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def update
    if current_user.client?
      @company = current_user.company
      @product = Product.find_by(token: params[:token])
      if @product.update(product_params)
        HistoricProduct.create!(product: @product, company: @company, price: @product.price)
        redirect_to clients_company_product_path(current_user.company, @product.token), notice: 'Opção atualizada com sucesso'
      else
        render :edit
      end
    else
      redirect_to root_path
    end
  end

  def product_status
    if current_user.client?
      @company = current_user.company
      @product = Product.find_by(token: params[:token])
      @product.inactive!
      @product.name = ''
      @product.save!
      redirect_to clients_company_products_path(current_user.company), notice: 'Produto excluído com sucesso'
    else
      redirect_to root_path
    end
  end 
  private
  def product_params
    params.require(:product).permit(:name, :price, :boleto_discount, :credit_card_discount, :pix_discount)
  end
end