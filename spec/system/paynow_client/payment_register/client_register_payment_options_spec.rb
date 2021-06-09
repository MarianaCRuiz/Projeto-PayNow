require 'rails_helper'

describe 'register payment options' do
  it 'see payment options' do
    company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , 
                              state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                              street: 'rua 1', number: '12', address_complement: '', 
                              billing_email: 'person1@codeplay.com',
                              token: SecureRandom.base58(20))
    PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, icon: fixture_file_upload('Boleto.jpg', ('image/jpg')))
    PaymentOption.create!(name: 'PIX', fee: 1.2, max_money_fee: 15)
    PaymentOption.create!(name: 'Cartão de Crédito_1', fee: 1.5, max_money_fee: 18)
    user_client_admin = User.create!(email:'user1@codeplay.com', password: '123456', role: 'client_admin', company: company)

    login_as user_client_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento' #Boleto PIX CC

    expect(page).to have_content('Adicionar Boleto')
    expect(page).to have_content('Adicionar PIX')
    expect(page).to have_content('Cartão de Crédito_1')
  end
  xit 'client_admin see payment options chosen' do   #ADICIONAR CC E PIX
    company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , 
                              state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                              street: 'rua 1', number: '12', address_complement: '', 
                              billing_email: 'person1@codeplay.com',
                              token: SecureRandom.base58(20))
    PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, icon: fixture_file_upload('Boleto.jpg', ('image/jpg')))
    boleto = BoletoRegisterOption.create!(bank_code: '001', agency_number: '3140', account_number: '111.444-2')

    BoletoCompany.create!(company: company, boleto_register_option: boleto)
    
    user_client = User.create!(email:'user1@codeplay.com', password: '123456', role: 'client', company: company)
    
    login_as user_client, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'

    expect(page).to have_content('001')
    expect(page).to have_content('3140')
    expect(page).to have_content('111.444-2')
  end
end