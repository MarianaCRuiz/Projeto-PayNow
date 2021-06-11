require 'rails_helper'

describe 'clients accounts from a registered company' do
  let(:user_client) {User.create!(email:'user2@codeplay.com', password: '123456', role: 0)}
  context 'client register' do
    it 'successfully' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')
      DomainRecord.create!(email_client_admin: 'admin@codeplay.com', domain: 'codeplay.com', company: company)

      visit root_path
      click_on 'Registrar-se'
      fill_in 'Email', with: 'user@codeplay.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      #lick_on 'Criar conta'
      expect{ click_on 'Criar conta' }.to change{ User.count }.by(1)
      
      expect(page).to have_content('user@codeplay.com')
      expect(page).to have_link('Codeplay SA')
      expect(User.last.company).to eq(company)
    end
    it 'cannot be blank' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')
      DomainRecord.create!(email_client_admin: 'user1@codeplay.com', domain: 'codeplay.com', company: company)

      visit root_path
      click_on 'Registrar-se'
      fill_in 'Email', with: ''
      fill_in 'Senha', with: ''
      fill_in 'Confirmar senha', with: ''
      expect{ click_on 'Criar conta' }.to change{ User.count }.by(0)
      
      expect(page).to have_content('não pode ficar em branco', count: 3)
    end
    it 'already registered' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')
      DomainRecord.create!(email_client_admin: 'user1@codeplay.com', domain: 'codeplay.com', company: company)
      User.create!(email:'user2@codeplay.com', password: '123456', role: 0, company: company)
      
      visit root_path
      click_on 'Registrar-se'
      fill_in 'Email', with: 'user2@codeplay.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      expect{ click_on 'Criar conta' }.to change{ User.count }.by(0)

      expect(page).to have_content('Email já está em uso')
    end
    it 'cannot be a public domain' do
      visit root_path
      click_on 'Registrar-se'
      fill_in 'Email', with: 'user2@gmail.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      expect{ click_on 'Criar conta' }.to change{ User.count }.by(0)

      expect(page).to have_content('email inválido')
    end
  end
  context 'client edit' do
    it 'successfully' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')

      User.create!(email:'admin@codeplay.com', password: '123456', role: 1, company: company)
      user = User.create!(email:'user@codeplay.com', password: '123456', role: 0, company: company)
      DomainRecord.create!(email_client_admin: 'admin@codeplay.com', domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: 'admin@codeplay.com', domain: 'codeplay.com', company: company)

      login_as user, scope: :user
      visit root_path
      click_on 'Editar conta'
      fill_in 'Email', with: 'email@codeplay.com'
      fill_in 'Senha', with: '234567'
      fill_in 'Confirmar senha', with: '234567'
      fill_in 'Senha atual', with: '123456'
      click_on 'Atualizar'

      expect(page).to have_content('Sua conta foi atualizada com sucesso')
    end
    it 'email cannot be a public domain' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')

      User.create!(email:'admin@codeplay.com', password: '123456', role: 1, company: company)
      user = User.create!(email:'user@codeplay.com', password: '123456', role: 0, company: company)
      DomainRecord.create!(email_client_admin: 'admin@codeplay.com', domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: 'admin@codeplay.com', domain: 'codeplay.com', company: company)

      login_as user, scope: :user
      visit root_path
      click_on 'Editar conta'
      fill_in 'Email', with: 'email@gmail.com'
      fill_in 'Senha', with: '234567'
      fill_in 'Confirmar senha', with: '234567'
      fill_in 'Senha atual', with: '123456'
      click_on 'Atualizar'

      expect(page).to have_content('email inválido')
    end
    it 'cannot be blank' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')
      User.create!(email:'admin@codeplay.com', password: '123456', role: 1, company: company)
      user = User.create!(email:'user@codeplay.com', password: '123456', role: 0, company: company)
      DomainRecord.create!(email_client_admin: 'admin@codeplay.com', domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: 'admin@codeplay.com', domain: 'codeplay.com', company: company)
      
      login_as user, scope: :user
      visit root_path
      click_on 'Editar conta'
      fill_in 'Email', with: ''
      fill_in 'Senha', with: ''
      fill_in 'Confirmar senha', with: ''
      click_on 'Atualizar'

      expect(page).to have_content('não pode ficar em branco', count: 3)
    end
  end
  context 'client delete' do
    xit 'successfully' do
    end
  end
end