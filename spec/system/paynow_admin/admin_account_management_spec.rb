require 'rails_helper'

describe 'account admin' do
  context 'register admin' do
    it 'register allowed email in admin model' do
      Admin.create!(email: 'admin1@paynow.com.br')

      visit root_path
      click_on 'Registrar-se'
      fill_in 'Email', with: 'admin1@paynow.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      expect { click_on 'Criar conta' }.to change { User.count }.by(1)

      expect(current_path).to eq root_path
      expect(page).to have_content('admin1@paynow.com.br')
      expect(page).to have_link('Registro de opções de pagamento')
    end

    it 'cannot register without being in admin model' do
      visit root_path
      click_on 'Registrar-se'
      fill_in 'Email', with: 'admin3@paynow.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      expect { click_on 'Criar conta' }.to change { User.count }.by(0)

      expect(page).to have_content('email inválido')
      expect(page).to_not have_link('Registro de opções de pagamento')
    end
    it 'wrong confirmation password' do
      Admin.create!(email: 'admin1@paynow.com.br')

      visit root_path
      click_on 'Registrar-se'
      fill_in 'Email', with: 'admin1@paynow.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '111222'
      expect { click_on 'Criar conta' }.to change { User.count }.by(0)

      expect(page).to have_content('Confirmar senha não é igual a Senha')
    end
  end
  context 'login and recognize admin' do
    it 'successfully' do
      Admin.create!(email: 'admin@paynow.com.br')
      user = User.create!(email: 'admin@paynow.com.br', password: '123456', role: 2)

      visit root_path
      click_on 'Entrar'
      fill_in 'Email', with: 'admin@paynow.com.br'
      fill_in 'Senha', with: '123456'
      click_on 'Log in'

      expect(user.role).to eq('admin')
    end
    it 'email not registered' do
      visit root_path
      click_on 'Entrar'
      fill_in 'Email', with: 'admintestando@paynow.com.br'
      fill_in 'Senha', with: '123456'
      click_on 'Log in'

      expect(page).to have_content('Email ou senha inválida')
    end
    it 'wrong password' do
      Admin.create!(email: 'admin@paynow.com.br')
      User.create!(email: 'admin@paynow.com.br', password: '123456', role: 2)

      visit root_path
      click_on 'Entrar'
      fill_in 'Email', with: 'admin@paynow.com.br'
      fill_in 'Senha', with: '111333'
      click_on 'Log in'

      expect(page).to have_content('Email ou senha inválida')
    end
  end
  context 'changing password' do
    it 'successfully' do
      Admin.create!(email: 'admin@paynow.com.br')
      admin = User.create!(email: 'admin@paynow.com.br', password: '123456', role: 2)

      login_as admin, scope: :user
      visit root_path
      click_on 'Editar conta'
      fill_in 'Senha', with: '234567'
      fill_in 'Confirmar senha', with: '234567'
      fill_in 'Senha atual', with: '123456'
      click_on 'Atualizar'

      expect(page).to have_content('Sua conta foi atualizada com sucesso')
    end
    it 'wrong password' do
      Admin.create!(email: 'admin@paynow.com.br')
      admin = User.create!(email: 'admin@paynow.com.br', password: '123456', role: 2)

      login_as admin, scope: :user
      visit root_path
      click_on 'Editar conta'
      fill_in 'Senha', with: '234567'
      fill_in 'Confirmar senha', with: '234567'
      fill_in 'Senha atual', with: '444555'
      click_on 'Atualizar'

      expect(page).to have_content('Senha atual não é válido')
    end
  end
end
