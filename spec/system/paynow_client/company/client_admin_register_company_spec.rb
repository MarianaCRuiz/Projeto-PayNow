require 'rails_helper'

describe 'client_admin register' do
  let(:user_client_admin) {User.create!(email:'user1@codeplay.com', password: '123456', role: 3)}
  
  context 'company first register successfuly' do
    it 'client_admin register company' do
      login_as user_client_admin, scope: :user
      visit root_path
      click_on 'Registre sua empresa'
      fill_in 'Razão Social', with: 'Codeplay SA'
      fill_in 'CNPJ', with: '11.222.333/0001-44'
      fill_in 'Estado', with: 'São Paulo'
      fill_in 'Cidade', with: 'Campinas'
      fill_in 'Bairro', with: 'Centro'
      fill_in 'Rua', with: 'Emilio'
      fill_in 'Número', with: '123'
      fill_in 'Complemento', with: ''
      fill_in 'Email de faturamento', with: 'faturamento@codeplay.com'
      expect{ click_on 'Registrar' }.to change{ Company.count }.by(1)

      expect(page).to have_content('Codeplay SA')
      expect(page).to have_content('11.222.333/0001-44')
      expect(page).to have_content('Endereço de faturamento')
      expect(page).to have_content('São Paulo')
      expect(page).to have_content('Campinas')
      expect(page).to have_content('Centro')
      expect(page).to have_content('Emilio')
      expect(page).to have_content('123')
      expect(page).to have_content('Email de faturamento')
      expect(page).to have_content('faturamento@codeplay.com')
      expect(page).to have_link('Atualizar dados da empresa')
    end
  end
  context 'company first register failure' do
    it 'client_admin create account missing information' do
      visit root_path
      click_on 'Registrar-se'
      fill_in 'Email', with: ''
      fill_in 'Senha', with: ''
      fill_in 'Confirmar senha', with: ''
      click_on 'Criar conta'

      expect(page).to have_content('não pode ficar em branco', count: 3)
    end
    it 'client_admin register company missing information' do
      login_as user_client_admin, scope: :user
      visit root_path
      click_on 'Registre sua empresa'
      fill_in 'Razão Social', with: ''
      fill_in 'CNPJ', with: ''
      fill_in 'Estado', with: ''
      fill_in 'Cidade', with: ''
      fill_in 'Bairro', with: ''
      fill_in 'Rua', with: ''
      fill_in 'Número', with: ''
      fill_in 'Complemento', with: ''
      fill_in 'Email de faturamento', with: ''
      click_on 'Registrar'

      expect(page).to have_content('não pode ficar em branco', count: 8)
    end
  end
end