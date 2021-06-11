require 'rails_helper'  

describe 'view company' do
  context 'company profile' do
    it 'client_admin view company profile' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                  city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                  address_complement: '', billing_email: 'faturamento@codeplay.com')
      user_client_admin = User.create!(email:'user1@codeplay.com', password: '123456', role: 1, company: company)
      DomainRecord.create!(email_client_admin: user_client_admin.email, domain: 'codeplay.com', company: company)

      login_as user_client_admin, scope: :user
      visit root_path
      click_on 'Codeplay SA'
      
      expect(page).to have_content('Codeplay SA')
      expect(page).to have_content('11.222.333/0001-44')
      expect(page).to have_content('Endereço de faturamento')
      expect(page).to have_content('São Paulo')
      expect(page).to have_content('Campinas')
      expect(page).to have_content('Inova')
      expect(page).to have_content('rua 1')
      expect(page).to have_content('12')
      expect(page).to have_content('Email de faturamento')
      expect(page).to have_content('faturamento@codeplay.com')
      expect(page).to have_link('Atualizar dados da empresa')
    end
    it 'not client_admin cannot see client_admin company profile' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                  city: 'Campinas', district: 'Inova', street: 'rua 1', number: '123', 
                                  address_complement: '', billing_email: 'faturamento@codeplay.com')
      user_client = User.create!(email:'user1@codeplay.com', password: '123456', role: 0, company: company)
      DomainRecord.create!(email: user_client.email, domain: 'codeplay.com', company: company)
  
      login_as user_client, scope: :user
      visit root_path
      click_on 'Codeplay SA'
  
      expect(page).to_not have_link('Atualizar dados da empresa')
    end
  end
end