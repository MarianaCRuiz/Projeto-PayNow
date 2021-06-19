class ClientAdmin::ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.client_admin? || current_user.client_admin_sign_up? 
      @company = Company.find_by(token: params[:token])
      @products = Product.where(status: 0)  #order(:name)
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def show
    if current_user.client_admin? || current_user.client_admin_sign_up? 
      @company = current_user.company
      @product = Product.find_by(token: params[:token])
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  def new
    if current_user.client_admin? || current_user.client_admin_sign_up? 
      @company = current_user.company
      @product = Product.new
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  def create
    if current_user.client_admin? || current_user.client_admin_sign_up? 
      @company = current_user.company
      @product = @company.products.new(product_params)
      if @product.save
        HistoricProduct.create!(product: @product, company: @company, price: @product.price,
                                boleto_discount: @product.boleto_discount, 
                                credit_card_discount: @product.credit_card_discount, 
                                pix_discount: @product.pix_discount)
        redirect_to client_admin_company_product_path(@company.token, @product.token), notice: 'Opção adicionada com sucesso'
      else
        render :new
      end
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end
  def edit
    if current_user.client_admin? || current_user.client_admin_sign_up? 
      @company = current_user.company
      @product = Product.find_by(token: params[:token])
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def update
    if current_user.client_admin? || current_user.client_admin_sign_up? 
      @company = current_user.company
      @product = Product.find_by(token: params[:token])
      if @product.update(product_params)
        HistoricProduct.create!(product: @product, company: @company, price: @product.price, 
                                boleto_discount: @product.boleto_discount, 
                                credit_card_discount: @product.credit_card_discount, 
                                pix_discount: @product.pix_discount)
        redirect_to client_admin_company_product_path(current_user.company, @product.token), notice: 'Opção atualizada com sucesso'
      else
        render :edit
      end
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end

  def product_status
    if current_user.client_admin? || current_user.client_admin_sign_up? 
      @company = current_user.company
      @product = Product.find_by(token: params[:token])
      @product.inactive!
      @product.name = ''
      if @product.save
        redirect_to client_admin_company_products_path(current_user.company), notice: 'Produto excluído com sucesso'
      else
        redirect_to client_admin_company_products_path(current_user.company), notice: 'Não foi possível excluir'
      end
    else
      redirect_to root_path, notice: 'Acesso não autorizado'
    end
  end 
  private
  def product_params
    params.require(:product).permit(:name, :price, :boleto_discount, :credit_card_discount, :pix_discount)
  end
end