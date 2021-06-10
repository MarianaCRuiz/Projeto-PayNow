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
    xit 'cannot be blank' do
    end
    xit 'password confirmation wrong' do
    end
    context 'company' do
      it 'register company sucessfuly and became client_admin' do
        company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                    address_complement: '', billing_email: 'person1@codeplay.com')
        DomainRecord.create!(email_client_admin: 'user1@codeplay.com', domain: 'codeplay.com', company: company)
        user = User.create!(email:'user1@codeplay.com', password: '123456', role: 3, company: company)
        
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
        DomainRecord.create!(email_client_admin: 'user1@codeplay.com', domain: 'codeplay.com')
        user = User.create!(email:'user1@codeplay.com', password: '123456', role: 3)

        login_as user, scope: :user
        visit root_path
        
        expect(user.role).to eq('client_admin_sign_up')
        expect(page).to have_content('Registre sua empresa')
      end
    end
  end
  context 'edit' do
    xit 'successfully' do
    end
    xit 'cannot be blank' do
    end
  end
  context 'delete' do
    xit 'client_admin cannot delete' do #or needs to register other in his place...
    end
  end
end
