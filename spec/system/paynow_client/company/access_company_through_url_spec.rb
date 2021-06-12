require 'rails_helper'

describe 'cannot access through url' do
  context 'visitor' do
    it 'company profile' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '123', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')
      company.token = '5pjB8SDb74LH6bBnawe2'
      token = company.token
      visit "/client_admin/companies/#{token}"

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
    it 'edit company' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '123', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')
      company.token = '1pjB8SDb74LH1bBnawe2'
      token = company.token
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
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '123', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')
      user_client = User.create!(email:'user2@codeplay.com', password: '123456', role: 0)
      company.token = '5pjB8SDb74LH6bBnawe2'
      token = company.token

      login_as user_client, scope: :user
      visit "/client_admin/companies/#{token}"

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'edit company' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '123', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')
      company.token = '1pjB8SDb74LH1bBnawe2'
      token = company.token
      user_client = User.create!(email:'user2@codeplay.com', password: '123456', role: 0)
        
      login_as user_client, scope: :user
      visit "/client_admin/companies/#{token}/edit"

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'new company' do
      user_client = User.create!(email:'user2@codeplay.com', password: '123456', role: 0)
      login_as user_client, scope: :user
      visit "/client_admin/companies/new"

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
  end
end