require 'rails_helper'

describe 'register PIX option' do
  it 'client_admin register pix succesfully' do
    company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , 
                              state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                              street: 'rua 1', number: '12', address_complement: '', 
                              billing_email: 'person1@codeplay.com',
                              token: SecureRandom.base58(20))
    payment_option = PaymentOption.create!(name: 'PIX_1', fee: 1.1, max_money_fee: 24, icon: fixture_file_upload('CreditCard.jpg', ('image/jpg')))
  
    user_client_admin = User.create!(email:'user1@codeplay.com', password: '123456', role: 'client_admin', company: company)
    bank = BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')
    token = SecureRandom.base58(20)

    login_as user_client_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento' #Boleto PIX CC
    click_on 'Adicionar PIX_1'
    fill_in 'Chave PIX', with: token
    select "#{bank.code} - #{bank.bank}", from: 'Código do banco'
    click_on 'Registrar PIX'
  
    expect(page).to have_content('Opção adicionada com sucesso')
    expect(page).to have_content(token)
    expect(page).to have_content('PIX_1')
  end
  it 'cannot be blank' do
    company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , 
                              state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                              street: 'rua 1', number: '12', address_complement: '', 
                              billing_email: 'person1@codeplay.com',
                              token: SecureRandom.base58(20))
    payment_option = PaymentOption.create!(name: 'PIX_1', fee: 1.1, max_money_fee: 24, icon: fixture_file_upload('CreditCard.jpg', ('image/jpg')))
  
    user_client_admin = User.create!(email:'user1@codeplay.com', password: '123456', role: 'client_admin', company: company)
    bank = BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')
    token = SecureRandom.base58(20)

    login_as user_client_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento' #Boleto PIX CC
    click_on 'Adicionar PIX_1'
    fill_in 'Chave PIX', with: ''
    select "#{bank.code} - #{bank.bank}", from: 'Código do banco'
    click_on 'Registrar PIX'
  
    expect(page).to have_content('não pode ficar em branco')
  end
  it 'PIX key uniq' do
    company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , 
                              state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                              street: 'rua 1', number: '12', address_complement: '', 
                              billing_email: 'person1@codeplay.com',
                              token: SecureRandom.base58(20))
    payment_option = PaymentOption.create!(name: 'PIX_1', fee: 1.1, max_money_fee: 24, icon: fixture_file_upload('CreditCard.jpg', ('image/jpg')))
  
    user_client_admin = User.create!(email:'user1@codeplay.com', password: '123456', role: 'client_admin', company: company)
    bank = BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')
    token = 'abc123ABC456DEF98nm2'
    PixRegisterOption.create!(payment_option: payment_option, pix_key: token, bank_code: bank, company: company)
    

    login_as user_client_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento' #Boleto PIX CC
    click_on 'Adicionar PIX_1'
    fill_in 'Chave PIX', with: token
    select "#{bank.code} - #{bank.bank}", from: 'Código do banco'
    click_on 'Registrar PIX'
  
    expect(page).to have_content('já está em uso')
  end
end