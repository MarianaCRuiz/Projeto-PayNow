require 'rails_helper'

describe 'authentication' do
  let(:company) {Company.create!(corporate_name: 'Empresa 3 SA', cnpj: '11.222.333/0001-55' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@empresa3.com')}
  let(:user_admin) {User.create!(email: 'admin@empresa3.com', password: '123456', role: 1, company: company)}
  let(:user) {User.create!(email: 'user@empresa3.com', password: '123456', role: 0, company: company)}
  let(:product) {Product.create!(name:'Produto 1', price: 53, boleto_discount: 1, company: company)}
  
  context 'client_admin product register' do
    context 'visitor' do
      it 'index' do
        company1 = company
        visit client_admin_company_products_path(company1.token)
        
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
      it 'show' do
        HistoricProduct.create(product: product, company: company, price: product.price)

        visit client_admin_company_product_path(company.token, product.token)
        
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
      
    end
    context 'client' do
      it 'index' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'empresa3.com', company: company)
        DomainRecord.create!(email: user, domain: 'empresa3.com', company: company)
        company1 = company
        
        login_as user, scope: :user
        visit client_admin_company_products_path(company1.token)
        
        expect(current_path).to eq(root_path)
        expect(page).to have_content('Acesso não autorizado')
      end
      it 'show' do
        HistoricProduct.create(product: product, company: company, price: product.price)
        DomainRecord.create!(email_client_admin: user_admin, domain: 'empresa3.com', company: company)
        DomainRecord.create!(email: user, domain: 'empresa3.com', company: company)
       
        login_as user, scope: :user
        visit client_admin_company_product_path(company.token, product.token)
        
        expect(current_path).to eq(root_path)
        expect(page).to have_content('Acesso não autorizado')
      end 
      it 'new' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'empresa3.com', company: company)
        DomainRecord.create!(email: user, domain: 'empresa3.com', company: company)
        
        login_as user, scope: :user
        visit new_client_admin_company_product_path(company.token)
        
        expect(current_path).to eq(root_path)
        expect(page).to have_content('Acesso não autorizado')
      end
      it 'edit' do
        HistoricProduct.create(product: product, company: company, price: product.price)
        DomainRecord.create!(email_client_admin: user_admin, domain: 'empresa3.com', company: company)
        DomainRecord.create!(email: user, domain: 'empresa3.com', company: company)
        
        login_as user, scope: :user
        visit edit_client_admin_company_product_path(company.token, product.token)
        
        expect(current_path).to eq(root_path)
        expect(page).to have_content('Acesso não autorizado')
      end
    end
  end
end