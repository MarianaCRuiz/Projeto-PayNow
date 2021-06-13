require 'rails_helper'

describe 'cannot access through url' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:user) {User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company)}    
  context 'visitor' do
    it 'company profile' do
      company1 = company
      token = '5pjB8SDb74LH6bBnawe2'
      company.token = token
     
      visit "/client_admin/companies/#{token}"

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
    it 'edit company' do
      company1 = company
      token = '5pjB8SDb74LH6bBnawe2'
      company.token = token
      visit "/client_admin/companies/#{token}/edit"

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
    it 'new company' do
      visit "/client_admin/companies/new"

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
    it 'payment chosen' do
      visit "/client_admin/companies/payment_chosen"

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
  end
  context 'client' do
    it 'company profile' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
      token = '5pjB8SDb74LH6bBnawe2'
      company.token = token
      
      login_as user, scope: :user
      visit "/client_admin/companies/#{token}"

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'edit company' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
      token = '1pjB8SDb74LH1bBnawe2'
      company.token = token
      
      login_as user, scope: :user
      visit "/client_admin/companies/#{token}/edit"

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'new company' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)

      login_as user, scope: :user
      visit "/client_admin/companies/new"

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
  end
end