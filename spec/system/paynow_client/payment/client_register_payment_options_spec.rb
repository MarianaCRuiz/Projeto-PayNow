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
  it 'client_admin see payment options chosen' do  
    company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , 
                              state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                              street: 'rua 1', number: '12', address_complement: '', 
                              billing_email: 'person1@codeplay.com',
                              token: SecureRandom.base58(20))
    bank = BankCode.create(code: '001', bank:'Banco do Brasil S.A.')

    pay_1 = PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20)
    pay_2 = PaymentOption.create!(name: 'Cartão de Crédito', fee: 1.3, max_money_fee: 21)
    pay_3 = PaymentOption.create!(name: 'Pix', fee: 1.5, max_money_fee: 23)
    
    boleto = BoletoRegisterOption.create!(company: company, payment_option: pay_1, bank_code: bank, agency_number: '3140', account_number: '111.444-2')
    creditcard = CreditCardRegisterOption.create!(company: company, payment_option: pay_2, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
    pix = PixRegisterOption.create!(company: company, payment_option: pay_3, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)

    PaymentCompany.create(company: company, payment_option: pay_1)
    PaymentCompany.create!(company: company, payment_option: pay_2)
    PaymentCompany.create!(company: company, payment_option: pay_3)
    user_client = User.create!(email:'user1@codeplay.com', password: '123456', role: 'client', company: company)

    
    login_as user_client, scope: :user
    visit clients_company_path(company[:token])
    click_on 'Opções de pagamento'

    expect(page).to have_content('001')
    expect(page).to have_content('3140')
    expect(page).to have_content('111.444-2')
    expect(page).to have_content('Chave PIX: AJ86gt4fLBtcF296rTuN')
    expect(page).to have_content('Código da operadora: jdB8SD923Nmg8fR1GhJm')
  end
end