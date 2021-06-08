require 'rails_helper'

describe 'client_admin register' do
  let(:user_client_admin) {User.create!(email:'user1@codeplay.com', password: '123456', role: 2)}
  
  context 'company first register successfuly' do
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
   xit 'client _admin choose payment options' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , 
                                state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                street: 'rua 1', number: '12', address_complement: '', 
                                billing_email: 'person1@codeplay.com',
                                token: SecureRandom.base58(20))
      PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, icon: fixture_file_upload('Boleto.jpg', ('image/jpg')))
      PaymentOption.create!(name: 'PIX', fee: 1.2, max_money_fee: 15)
      PaymentOption.create!(name: 'Cartão de Crédito', fee: 1.5, max_money_fee: 18)
      user_client = User.create!(email:'user1@codeplay.com', password: '123456', role: 'client', company: company)
      
      login_as user_client, scope: :user
      visit client_admin_company_path(company[:token])
      click_on 'Opções de pagamento'
      click_on 'Adicionar opções de pagamento'
      check ('Boleto')
      check ('PIX')
      
      expect(page).to have_content('Boleto')
      expect(page).to have_content('PIX')
      expect(page).to_not have_content('Cartão de Crédito')
      
    end
    xit 'token must be uniq' do

    end
  end
  context 'company first register failure' do
    xit 'client_admin create account missing information' do
    end
    xit 'client_admin register company missing information' do
    end
    xit 'client _admin choose no payment options' do
    end
  end
  context 'company profile' do
    xit 'client_admin view profile' do
    end
    xit 'client_admin edit profile' do
    end
    xit 'client_admin edit profile failure' do
    end
    xit 'client_not_admin cannot edit company profile' do
    end
  end
end