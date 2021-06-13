require 'rails_helper'

describe 'authentication' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:user) {User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company)}    
  
  context 'visitor' do
    xit 'POST' do
      company2 = company
      post client_admin_company_products_path(company2.token), params: {payment_option: {name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0}}

      expect(response).to redirect_to(new_user_session_path)
    end
    xit 'PATCH' do
      option = PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)
      
      patch admin_payment_option_path(option)
        
      expect(response).to redirect_to(new_user_session_path)
    end
  end
  context 'client_admin' do
    xit 'POST' do
      
      login_as user_admin, scope: :user
      post client_admin_company_products_path, params: {payment_option: {name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0}}
  
      expect(response).to redirect_to(root_path)
    end
    xit 'PATCH' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
      
      login_as user_admin, scope: :user
      option = PaymentOption.create(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)
        
      patch admin_payment_option_path(option)
          
      expect(response).to redirect_to(root_path)
    end
  end
  context 'client' do
    xit 'POST' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        
      login_as user_admin, scope: :user
      post client_admin_company_products_path, params: {payment_option: {name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0}}
    
      expect(response).to redirect_to(root_path)
    end
    xit 'PATCH' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        
      login_as user_admin, scope: :user
      option = PaymentOption.create(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)
          
      patch admin_payment_option_path(option)
            
      expect(response).to redirect_to(root_path)
    end
  end
end
