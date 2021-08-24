require 'rails_helper'

describe 'client_admin view company' do
  context 'company profile' do
    it 'admin view companies' do
      Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                      city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                      address_complement: '', billing_email: 'faturamento@codeplay.com')
      Company.create!(corporate_name: 'Empresa SA', cnpj: '11.222.888/0001-44', state: 'São Paulo',
                      city: 'Campinas', district: 'bairro x', street: 'rua 1', number: '12',
                      address_complement: '', billing_email: 'faturamento@empresa.com')
      Admin.create!(email: 'user1@paynow.com.br')
      admin = User.create!(email: 'user1@paynow.com.br', password: '123456', role: 2)

      login_as admin, scope: :user
      visit root_path
      click_on 'Empresas cadastradas'

      expect(page).to have_content('Codeplay SA')
      expect(page).to have_content('Empresa SA')
    end
    it 'admin view company profile' do
      Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                      city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                      address_complement: '', billing_email: 'faturamento@codeplay.com')
      Admin.create!(email: 'user1@paynow.com.br')
      admin = User.create!(email: 'user1@paynow.com.br', password: '123456', role: 2)

      login_as admin, scope: :user
      visit root_path
      click_on 'Empresas cadastradas'
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
      expect(page).to have_link('Atualizar dados da empresa')
    end
  end
end
