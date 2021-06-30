require 'rails_helper'

describe 'client_admin account' do
  context 'register' do
    it 'client_admin create account' do
      visit root_path
      click_on 'Registrar-se'
      fill_in 'Email', with: 'client1@codeplay.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      expect{ click_on 'Criar conta' }.to change{ User.count }.by(1)
    
      expect(current_path).to eq root_path
      expect(page).to have_content('client1@codeplay.com.br')
      expect(page).to have_link('Registre sua empresa')
    end
    it 'cannot be blank' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')
      
      visit root_path
      click_on 'Registrar-se'
      fill_in 'Email', with: ''
      fill_in 'Senha', with: ''
      fill_in 'Confirmar senha', with: ''
      expect{ click_on 'Criar conta' }.to change{ User.count }.by(0)
      
      expect(page).to have_content('não pode ficar em branco', count: 3)
    end
    it 'password confirmation wrong' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')
      
      visit root_path
      click_on 'Registrar-se'
      fill_in 'Email', with: 'client1@codeplay.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '33'
      expect{ click_on 'Criar conta' }.to change{ User.count }.by(0)
      
      expect(page).to have_content('Não foi possível salvar usuário(a)')
      expect(page).to have_content('Confirmar senha não é igual a Senha')
    end
    
    context 'company' do
      it 'register company sucessfuly and became client_admin' do
        company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                    address_complement: '', billing_email: 'faturamento@codeplay.com')
        user = User.create!(email:'user1@codeplay.com', password: '123456', role: 3, company: company)
        DomainRecord.find_by(email_client_admin: 'user1@codeplay.com').update!(company: company)
        
        login_as user, scope: :user
        visit root_path
        click_on 'Sair'
        visit root_path
        click_on 'Entrar'
        fill_in 'Email', with: 'user1@codeplay.com'
        fill_in 'Senha', with: '123456'
        click_on 'Log in'
        
        expect(user.role).to eq('client_admin')
      end

      it 'fail to register company keep being client_admin_sign_up ' do
        user = User.create!(email:'user1@codeplay.com', password: '123456', role: 3)

        login_as user, scope: :user
        visit root_path
        click_on 'Sair'
        login_as user, scope: :user
        visit root_path
        
        expect(user.role).to eq('client_admin_sign_up')
        expect(page).to have_content('Registre sua empresa')
      end
    end
  end
  context 'edit' do
    it 'successfully' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')

      user_client_admin = User.create!(email:'admin@codeplay.com', password: '123456', role: 1, company: company)
      rec = DomainRecord.find_by(email_client_admin: 'admin@codeplay.com').update!(company: company)
      
      login_as user_client_admin, scope: :user
      visit root_path
      click_on 'Editar conta'
      fill_in 'Email', with: 'adminnovo@codeplay.com'
      fill_in 'Senha', with: '234567'
      fill_in 'Confirmar senha', with: '234567'
      fill_in 'Senha atual', with: '123456'
      click_on 'Atualizar'

      expect(page).to have_content('Sua conta foi atualizada com sucesso')
    end
    it 'cannot be blank' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')
      user_client_admin = User.create!(email:'admin@codeplay.com', password: '123456', role: 1, company: company)
      rec = DomainRecord.find_by(email_client_admin: 'admin@codeplay.com').update!(company: company)
      
      login_as user_client_admin, scope: :user
      visit root_path
      click_on 'Editar conta'
      fill_in 'Email', with: ''
      fill_in 'Senha', with: ''
      fill_in 'Confirmar senha', with: ''
      click_on 'Atualizar'

      expect(page).to have_content('não pode ficar em branco', count: 3)
    end
  end
end
