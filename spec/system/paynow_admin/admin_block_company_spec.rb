require 'rails_helper'

describe 'admin block company' do
  context 'blocking' do
    xit 'successfuly' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')
      client_admin = User.create!(email:'admin@codeplay.com', password: '123456', role: 1, company: company)
      client = User.create!(email:'user@codeplay.com', password: '123456', role: 0, company: company)
      admin = User.create!(email:'admin@paynow.com.br', password: '123456', role: 2, company: company)
      DomainRecord.create!(email_client_admin: client_admin.email, domain: 'codeplay.com', company: company)
      DomainRecord.create!(email_client_admin: client.email, domain: 'codeplay.com', company: company)
      
      login_as admin, scope: :user
      visit root_path
      click_on 'Codeplay SA'
      click_on 'Bloquear'

      

    end
    xit 'faillure, do not receive confirmation' do    
    end
  end  
  context 'after blocking' do
    xit 'client cannot access account' do
    end
    xit 'client cannot issue charges' do
    end
  end
end