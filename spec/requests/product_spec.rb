require 'rails_helper'

describe 'authentication' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:user) {User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company)}    
  let(:product) {Product.create!(name:'Produto 1', price: 53, boleto_discount: 1, company: company)}
  context 'visitor' do
    it 'POST' do
      company2 = company

      post client_admin_company_products_path(company.token), params: {product: {name:'Produto 1', price: 53, boleto_discount: 1, company: company}}

      expect(response).to redirect_to(new_user_session_path)
    end
    it 'PATCH update' do
      company2 = company
      product2 = product
      
      patch client_admin_company_product_path(company.token, product.token)
        
      expect(response).to redirect_to(new_user_session_path)
    end
    it 'PATCH status' do
      company2 = company
      product2 = product
      
      patch product_status_client_admin_company_product_path(company.token, product.token)
        
      expect(response).to redirect_to(new_user_session_path)
    end
  end
  context 'client' do
    it 'POST' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
      company2 = company

      login_as user, scope: :user
      post client_admin_company_products_path(company.token), params: {product: {name:'Produto 1', price: 53, boleto_discount: 1, company: company}}
    
      expect(response).to redirect_to(root_path)
    end
    it 'PATCH update' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
      company2 = company
      product2 = product

      login_as user, scope: :user
      
      patch client_admin_company_product_path(company.token, product.token)
            
      expect(response).to redirect_to(root_path)
    end
    it 'PATCH status' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
      company2 = company
      product2 = product

      login_as user, scope: :user
      
      patch product_status_client_admin_company_product_path(company.token, product.token)
            
      expect(response).to redirect_to(root_path)
    end
  end
end
