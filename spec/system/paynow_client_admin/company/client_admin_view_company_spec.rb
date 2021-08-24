require 'rails_helper'

describe 'client_admin view company' do
  context 'company profile' do
    it 'client_admin view company profile' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo',
                                  city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                                  address_complement: '', billing_email: 'faturamento@codeplay.com')
      user_admin = User.create!(email:'user1@codeplay.com', password: '123456', role: 1, company: company)

      login_as user_admin, scope: :user
      visit root_path
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
    it 'company not registered' do
      user_admin = User.create!(email:'user1@codeplay.com', password: '123456', role: 3)

      login_as user_admin, scope: :user
      visit root_path

      expect(page).to_not have_link('Codeplay SA')
    end
  end
end
