require 'rails_helper'

describe 'register Boleto' do
    it 'client_admin register boleto succesfully' do
    company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , 
                              state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                              street: 'rua 1', number: '12', address_complement: '', 
                              billing_email: 'person1@codeplay.com',
                              token: SecureRandom.base58(20))
    PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, icon: fixture_file_upload('Boleto.jpg', ('image/jpg')))
  
    user_client_admin = User.create!(email:'user1@codeplay.com', password: '123456', role: 'client_admin', company: company)
    
    login_as user_client_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento' #Boleto PIX CC
    click_on 'Adicionar Boleto'
    fill_in 'Código do banco', with: '001'
    fill_in 'Agência', with: '3040'
    fill_in 'Número da conta', with: '111.222-3'
    click_on 'Registrar boleto'
  
    expect(page).to have_content('Opção adicionada com sucesso')
    expect(page).to have_content('001')
    expect(page).to have_content('3040')
    expect(page).to have_content('111.222-3')
  end
  xit 'cannot be blank' do
  end
  xit 'bank code from FEBRABAN' do
  end
end