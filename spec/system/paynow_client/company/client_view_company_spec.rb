require 'rails_helper'  

describe 'view company' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:user) {User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company)}    
  
  context 'company profile' do
    it 'client view company profile' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
      
      login_as user, scope: :user
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
      expect(page).to_not have_link('Atualizar dados da empresa')
    end
    it 'client not admin cannot see edit company link' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
  
      login_as user, scope: :user
      visit root_path
      click_on 'Codeplay SA'
  
      expect(page).to_not have_link('Atualizar dados da empresa')
    end
  end
end