class ClientAdmin::ProductsController < ApplicationController
  def index
    @company = Company.find_by(token: params[:token])
    @products = Product.all  #order(:name)
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
    if @product.save!
      HistoricProduct.create!(product: @product, company: @company, price: @product.price)
      redirect_to client_admin_company_product_path(@company.token, @product.token), notice: 'Opção adicionada com sucesso'
    else
      byebug
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :price, :boleto_discount, :credit_card_discount, :pix_discount)
  end
end