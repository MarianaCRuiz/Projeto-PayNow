require 'rails_helper'

describe 'register payment options' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:pay_boleto_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:pay_creditcard_1) {PaymentOption.create!(name: 'Cartão de Crédito MASTERCHEF', fee: 1.9, max_money_fee: 20, payment_type: 1)}
  let(:pay_pix_1) {PaymentOption.create!(name: 'PIX_1', fee: 1.9, max_money_fee: 20, payment_type: 2)}

  it 'see availables payment options chosen' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    PaymentCompany.create(company: company, payment_option: pay_boleto_1)
    PaymentCompany.create!(company: company, payment_option: pay_creditcard_1)
    boleto = pay_boleto_1
    cc = pay_creditcard_1
    pix = pay_pix_1

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'

    expect(page).to have_content('Boleto')
    expect(page).to have_content('Cartão de Crédito MASTERCHEF')
    expect(page).to_not have_content('PIX_1')
  end
  it 'see availables payment options' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    boleto = pay_boleto_1
    cc = pay_creditcard_1
    pix = pay_pix_1

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento'

    expect(page).to have_content('Adicionar: Boleto')
    expect(page).to have_content('Adicionar: PIX_1')
    expect(page).to have_content('Adicionar: Cartão de Crédito MASTERCHEF')
  end
  it 'client_admin see payment options chosen' do  
    bank = BankCode.create(code: '001', bank:'Banco do Brasil S.A.')
    boleto = BoletoRegisterOption.create!(company: company, payment_option: pay_boleto_1, bank_code: bank, agency_number: '3140', account_number: '111.444-2')
    creditcard = CreditCardRegisterOption.create!(company: company, payment_option: pay_creditcard_1, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
    pix = PixRegisterOption.create!(company: company, payment_option: pay_pix_1, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)
    PaymentCompany.create(company: company, payment_option: pay_boleto_1)
    PaymentCompany.create!(company: company, payment_option: pay_creditcard_1)
    PaymentCompany.create!(company: company, payment_option: pay_pix_1)
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

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
    pay_boleto_1 = PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0, icon: fixture_file_upload('Boleto.jpg', ('image/jpg')))
    pay_creditcard_1 = PaymentOption.create!(name: 'PIX', fee: 1.2, max_money_fee: 15, state: 1, payment_type: 2)
    pay_pix_1 = PaymentOption.create!(name: 'Cartão de Crédito_1', fee: 1.5, max_money_fee: 18, state: 1, payment_type: 1)
    PaymentCompany.create(company: company, payment_option: pay_boleto_1)
    PaymentCompany.create!(company: company, payment_option: pay_creditcard_1)
    PaymentCompany.create!(company: company, payment_option: pay_pix_1)
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    
    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'

    expect(page).to have_content('Boleto')
    expect(page).to_not have_content('PIX')
    expect(page).to_not have_content('Cartão de Crédito_1')
  end
end