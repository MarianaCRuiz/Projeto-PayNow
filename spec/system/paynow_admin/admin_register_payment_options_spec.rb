require 'rails_helper'

describe 'payment options' do
  let(:user) do
    User.create!(email: 'admin1@paynow.com.br', password: '123456', password_confirmation: '123456', role: 'admin')
  end
  context 'register successfully' do
    it 'boleto' do
      Admin.create!(email: 'admin1@paynow.com.br')

      login_as user, scope: :user
      visit root_path
      click_on 'Registro de opções de pagamento'
      click_on 'Adicionar opções de pagamento'
      select 'Boleto', from: 'Tipo'
      fill_in 'Nome', with: 'Boleto'
      fill_in 'Taxa', with: 1.5
      fill_in 'Taxa máxima', with: 10
      attach_file('icon', Rails.root.join('spec/fixtures/files/Boleto.jpg'))
      expect { click_on 'Adicionar' }.to change { PaymentOption.count }.by(1)

      expect(page).to have_content('Boleto')
      expect(page).to have_content('1,50')
      expect(page).to have_content('10,00')
      expect(page).to have_link('Voltar')
      expect(page).to have_css('img[src*="Boleto.jpg"]')
    end
    it 'PIX' do
      Admin.create!(email: 'admin1@paynow.com.br')

      login_as user, scope: :user
      visit root_path
      click_on 'Registro de opções de pagamento'
      click_on 'Adicionar opções de pagamento'
      select 'PIX', from: 'Tipo'
      fill_in 'Nome', with: 'PIX'
      fill_in 'Taxa', with: 1.2
      fill_in 'Taxa máxima', with: 12
      expect { click_on 'Adicionar' }.to change { PaymentOption.count }.by(1)

      expect(page).to have_content('PIX')
      expect(page).to have_content('1,20')
      expect(page).to have_content('12,00')
      expect(page).to have_link('Voltar')
    end
    it 'creditcard' do
      Admin.create!(email: 'admin1@paynow.com.br')

      login_as user, scope: :user
      visit root_path
      click_on 'Registro de opções de pagamento'
      click_on 'Adicionar opções de pagamento'
      select 'Cartão de Crédito', from: 'Tipo'
      fill_in 'Nome', with: 'Cartão de Crédito MASTERCHEF'
      fill_in 'Taxa', with: 1.1
      fill_in 'Taxa máxima', with: 11
      expect { click_on 'Adicionar' }.to change { PaymentOption.count }.by(1)

      expect(page).to have_content('Cartão de Crédito MASTERCHEF')
      expect(page).to have_content('1,10')
      expect(page).to have_content('11,00')
      expect(page).to have_link('Voltar')
    end
  end
  context 'register failure' do
    it 'missing information' do
      Admin.create!(email: 'admin1@paynow.com.br')

      login_as user, scope: :user
      visit root_path
      click_on 'Registro de opções de pagamento'
      click_on 'Adicionar opções de pagamento'
      select 'Boleto', from: 'Tipo'
      fill_in 'Nome', with: ''
      fill_in 'Taxa', with: ''
      fill_in 'Taxa máxima', with: ''
      expect { click_on 'Adicionar' }.to change { PaymentOption.count }.by(0)

      expect(page).to have_content('não pode ficar em branco', count: 3)
    end
    it 'name uniq' do
      Admin.create!(email: 'admin1@paynow.com.br')
      PaymentOption.create!(name: 'Cartão de Crédito MASTERCHEF', fee: 1.1, max_money_fee: 12, payment_type: 1)

      login_as user, scope: :user
      visit root_path
      click_on 'Registro de opções de pagamento'
      click_on 'Adicionar opções de pagamento'
      select 'Cartão de Crédito', from: 'Tipo'
      fill_in 'Nome', with: 'Cartão de Crédito MASTERCHEF'
      fill_in 'Taxa', with: 1.1
      fill_in 'Taxa máxima', with: 11
      expect { click_on 'Adicionar' }.to change { PaymentOption.count }.by(0)

      expect(page).to have_content('já está em uso')
    end
  end
end
