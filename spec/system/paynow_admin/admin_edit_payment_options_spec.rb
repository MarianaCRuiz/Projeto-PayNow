require 'rails_helper'

describe 'payment options' do
  let(:user) {User.create!(email: 'admin1@paynow.com.br', password: '123456', password_confirmation: '123456', role: 'admin')}
  context 'edit successfully' do
    it 'params' do
      Admin.create!(email: 'admin1@paynow.com.br')
      option = PaymentOption.create(name: 'Boleto', fee: 1.9, max_money_fee: 20)

      login_as user, scope: :user
      visit root_path
      click_on 'Registro de opções de pagamento'
      click_on "Atualizar #{option.name}"
      fill_in 'Nome', with: 'Boleto BB'
      fill_in 'Taxa', with: 1.2
      fill_in 'Taxa máxima', with: 12
      expect{ click_on 'Atualizar' }.to change{ PaymentOption.count }.by(0)

      expect(page).to have_content('Boleto')
      expect(page).to have_content('1,20')
      expect(page).to have_content('12,00')
      expect(page).to have_link('Voltar')
    end
    it 'status' do
      Admin.create!(email: 'admin1@paynow.com.br')
      option = PaymentOption.create(name: 'Boleto', fee: 1.9, max_money_fee: 20)

      login_as user, scope: :user
      visit root_path
      click_on 'Registro de opções de pagamento'
      click_on "Atualizar #{option.name}"
      fill_in 'Nome', with: 'PIX'
      fill_in 'Taxa', with: 1.2
      fill_in 'Taxa máxima', with: 12
      check('check')
      expect{ click_on 'Atualizar' }.to change{ PaymentOption.count }.by(0)

      expect(page).to have_content('PIX')
      expect(page).to have_content('1,20')
      expect(page).to have_content('12,00')
      expect(page).to have_content('Inativo')
      expect(page).to have_link('Voltar')
    end
  end
  context 'register failure' do
    it 'missing information' do
      Admin.create!(email: 'admin1@paynow.com.br')
      option = PaymentOption.create(name: 'Boleto', fee: 1.9, max_money_fee: 20)

      login_as user, scope: :user
      visit root_path
      click_on 'Registro de opções de pagamento'
      click_on "Atualizar #{option.name}"
      fill_in 'Nome', with: ''
      fill_in 'Taxa', with: ''
      fill_in 'Taxa máxima', with: ''
      expect{ click_on 'Atualizar' }.to change{ PaymentOption.count }.by(0)

      expect(page).to have_content('não pode ficar em branco', count: 3)
    end
    it 'name uniq' do
      Admin.create!(email: 'admin1@paynow.com.br')
      option = PaymentOption.create(name: 'Cartão de Crédito PISA', fee: 1.9, max_money_fee: 20)
      option = PaymentOption.create!(name: 'Cartão de Crédito MASTERCHEF', fee: 1.1, max_money_fee: 12)

      login_as user, scope: :user
      visit root_path
      click_on 'Registro de opções de pagamento'
      click_on "Atualizar #{option.name}"
      fill_in 'Nome', with: 'Cartão de Crédito PISA'
      fill_in 'Taxa', with: 1.1
      fill_in 'Taxa máxima', with: 11
      expect{ click_on 'Atualizar' }.to change{ PaymentOption.count }.by(0)

      expect(page).to have_content('já está em uso')
    end
  end
  it 'show option deactivated' do
    Admin.create!(email: 'admin1@paynow.com.br')
    option = PaymentOption.create(name: 'Boleto', fee: 1.9, max_money_fee: 20)

    login_as user, scope: :user
    visit root_path
    click_on 'Registro de opções de pagamento'
    click_on "Atualizar #{option.name}"
    fill_in 'Nome', with: 'Boleto BB'
    fill_in 'Taxa', with: 1.2
    fill_in 'Taxa máxima', with: 12
    check('check')
    expect{ click_on 'Atualizar' }.to change{ PaymentOption.count }.by(0)

    expect(page).to have_content('Boleto')
    expect(page).to have_content('1,20')
    expect(page).to have_content('12,00')
    expect(page).to have_content('Inativo')
  end
end
