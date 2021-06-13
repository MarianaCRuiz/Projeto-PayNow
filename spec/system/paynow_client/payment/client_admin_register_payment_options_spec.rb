require 'rails_helper'

describe 'register payment options' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:pay_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:pay_2) {PaymentOption.create!(name: 'Cartão de Crédito MASTERCHEF', fee: 1.9, max_money_fee: 20, payment_type: 1)}
  let(:pay_3) {PaymentOption.create!(name: 'PIX_1', fee: 1.9, max_money_fee: 20, payment_type: 2)}

  xit 'see availables payment options' do
    boleto = pay_1
    cc = pay_2
    pix = pay_3

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento'

    expect(page).to have_content('Adicionar: Boleto')
    expect(page).to have_content('Adicionar: PIX')
    expect(page).to have_content('Adicionar: Cartão de Crédito_1')
  end
  it 'do not see unavailables payment options' do
    boleto = pay_1
    cc = pay_2
    pix = pay_3

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento'

    expect(page).to have_content('Adicionar: Boleto')
    expect(page).to have_content('Adicionar: PIX')
    expect(page).to_not have_content('Adicionar: Cartão de Crédito_1')
  end
  it 'client_admin see payment options chosen' do  
    bank = BankCode.create(code: '001', bank:'Banco do Brasil S.A.')
    boleto = BoletoRegisterOption.create!(company: company, payment_option: pay_1, bank_code: bank, agency_number: '3140', account_number: '111.444-2')
    creditcard = CreditCardRegisterOption.create!(company: company, payment_option: pay_2, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
    pix = PixRegisterOption.create!(company: company, payment_option: pay_3, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)
    PaymentCompany.create(company: company, payment_option: pay_1)
    PaymentCompany.create!(company: company, payment_option: pay_2)
    PaymentCompany.create!(company: company, payment_option: pay_3)

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'

    expect(page).to have_content('001')
    expect(page).to have_content('3140')
    expect(page).to have_content('111.444-2')
    expect(page).to have_content('Chave PIX: AJ86gt4fLBtcF296rTuN')
    expect(page).to have_content('Código da operadora: jdB8SD923Nmg8fR1GhJm')
  end
  it 'do not see unavailables payment options chosen' do
    pay_1 = PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0, icon: fixture_file_upload('Boleto.jpg', ('image/jpg')))
    pay_2 = PaymentOption.create!(name: 'PIX', fee: 1.2, max_money_fee: 15, state: 1, payment_type: 2)
    pay_3 = PaymentOption.create!(name: 'Cartão de Crédito_1', fee: 1.5, max_money_fee: 18, state: 1, payment_type: 1)
    PaymentCompany.create(company: company, payment_option: pay_1)
    PaymentCompany.create!(company: company, payment_option: pay_2)
    PaymentCompany.create!(company: company, payment_option: pay_3)
    
    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'

    expect(page).to have_content('Boleto')
    expect(page).to_not have_content('PIX')
    expect(page).to_not have_content('Cartão de Crédito_1')
  end
end