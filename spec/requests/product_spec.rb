require 'rails_helper'

describe 'authentication' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:user_admin) { User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company) }
  let(:user) { User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company) }
  let(:product) { Product.create!(name: 'Produto 1', price: 53, boleto_discount: 1, company: company) }
  context 'visitor' do
    it 'POST' do
      company

      post client_admin_company_products_path(company.token),
           params: { product: { name: 'Produto 1', price: 53, boleto_discount: 1, company: company } }

      expect(response).to redirect_to(new_user_session_path)
    end
    it 'PATCH update' do
      company
      product

      patch client_admin_company_product_path(company.token, product.token)

      expect(response).to redirect_to(new_user_session_path)
    end
    it 'PATCH status' do
      company
      product

      patch product_status_client_admin_company_product_path(company.token, product.token)

      expect(response).to redirect_to(new_user_session_path)
    end
  end
  context 'client' do
    it 'POST' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      company

      login_as user, scope: :user
      post client_admin_company_products_path(company.token),
           params: { product: { name: 'Produto 1', price: 53, boleto_discount: 1, company: company } }

      expect(response).to redirect_to(root_path)
    end
    it 'PATCH update' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      company
      product

      login_as user, scope: :user

      patch client_admin_company_product_path(company.token, product.token)

      expect(response).to redirect_to(root_path)
    end
    it 'PATCH status' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      company
      product

      login_as user, scope: :user
      patch product_status_client_admin_company_product_path(company.token, product.token)

      expect(response).to redirect_to(root_path)
    end
  end
  context 'client_admin' do
    it 'POST' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      company

      login_as user_admin, scope: :user
      post clients_company_products_path(company.token),
           params: { product: { name: 'Produto 1', price: 53, boleto_discount: 1, company: company } }

      expect(response).to redirect_to(root_path)
    end
    it 'PATCH update' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      company
      product

      login_as user_admin, scope: :user
      patch clients_company_product_path(company.token, product.token)

      expect(response).to redirect_to(root_path)
    end
    it 'PATCH status' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      company
      product

      login_as user_admin, scope: :user
      patch product_status_clients_company_product_path(company.token, product.token)

      expect(response).to redirect_to(root_path)
    end
  end
end
