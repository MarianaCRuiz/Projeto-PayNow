require 'rails_helper'

describe 'authentication' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:user) {User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company)}    
  
  context 'client_admin controller' do
    context 'visitor' do
      it 'POST' do
        post client_admin_companies_path, params: {company: {corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                          city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                          address_complement: '', billing_email: 'faturamento@codeplay.com'}}
        expect(response).to redirect_to(new_user_session_path)
      end
      it 'PATCH UPDATE' do
        company_1 = company
        patch client_admin_company_path(company_1.token)
        expect(response).to redirect_to(new_user_session_path)
      end
      it 'PATCH new token' do
        company_1 = company
        patch token_new_client_admin_company_path(company_1.token)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context 'client' do
      it 'POST' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
          
        login_as user, scope: :user
        post client_admin_companies_path, params: {company: {corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                          city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                          address_complement: '', billing_email: 'faturamento@codeplay.com'}}
      
        expect(response).to redirect_to(root_path)
      end
      it 'PATCH UPDATE' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        company_1 = company

        login_as user, scope: :user
        patch client_admin_company_path(company_1.token)
              
        expect(response).to redirect_to(root_path)
      end
      it 'PATCH new token' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        company_1 = company

        login_as user, scope: :user
        patch token_new_client_admin_company_path(company_1.token)
        
        expect(response).to redirect_to(root_path)
      end
    end
  end
  context 'admin controller' do
    xit 'POST' do
      
    end
    xit 'PATCH UPDATE' do
      
    end
  end
end       