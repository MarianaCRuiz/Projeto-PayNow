require 'rails_helper'

describe 'account admin' do
  context 'login and recognize admin' do
    xit 'successfully' do
    end
    xit 'email not registered' do
    end
    xit 'wrong password' do
    end
  end 
  context 'register admin' do
    it 'register allowed email in admin model' do
      Admin.create!(email: 'admin1@paynow.com.br')
      
      visit root_path
      click_on 'Registrar-se'
      fill_in 'Email', with: 'admin1@paynow.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      expect{ click_on 'Criar conta' }.to change{ User.count }.by(1)

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
      expect{ click_on 'Criar conta' }.to change{ User.count }.by(0)

      expect(page).to have_content('email inválido')
      expect(page).to_not have_link('Registro de opções de pagamento') 
    end
    xit 'wrong confirmation password' do
    end
    xit 'permittion rejected' do
    end
  end
  context 'edit admin' do
    xit 'successfully' do
    end
    xit 'email invalid' do
    end
    xit 'wrong password' do
    end
  end
  context 'blcok admin' do
    xit 'successfully' do
    end
  end     
end