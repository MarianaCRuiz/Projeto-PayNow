require 'rails_helper'

describe 'register PIX option' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:pay_pix_1) {PaymentOption.create!(name: 'PIX_1', fee: 1.9, max_money_fee: 20, payment_type: 2)}
  let(:bank_code) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  let(:pix_option) {PixRegisterOption.create!(company: company, payment_option: pay_pix_1, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank_code)}
  
  it 'client_admin register pix succesfully' do
    PaymentCompany.create!(company: company, payment_option: pay_pix_1)
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    bank = bank_code
    token = SecureRandom.base58(20)
    pay = pay_pix_1
    pix = pix_option

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on "Atualizar #{pix.payment_option.name}"
    fill_in 'Chave PIX', with: token
    select "#{bank.code} - #{bank.bank}", from: 'Código do banco'
    click_on 'Atualizar'
  
    expect(page).to have_content('Opção atualizada com sucesso')
    expect(page).to have_content(token)
    expect(page).to have_content('PIX_1')
  end
  it 'cannot be blank' do
    PaymentCompany.create!(company: company, payment_option: pay_pix_1)
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    bank = bank_code
    token = SecureRandom.base58(20)
    bank = bank_code
    pay = pay_pix_1
    pix = pix_option

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on "Atualizar #{pix.payment_option.name}"
    fill_in 'Chave PIX', with: ''
    select "#{bank.code} - #{bank.bank}", from: 'Código do banco'
    click_on 'Atualizar'
  
    expect(page).to have_content('não pode ficar em branco')
  end
  it 'PIX key uniq' do
    PaymentCompany.create!(company: company, payment_option: pay_pix_1)
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    bank = bank_code
    token = 'abc123ABC456DEF98nm2'
    pay = pay_pix_1
    pix = pix_option
    pay_novo = PaymentOption.create!(name: 'PIX_2', fee: 1.9, max_money_fee: 20)
    PixRegisterOption.create!(payment_option: pay_novo, pix_key: token, bank_code: bank, company: company)

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on "Atualizar #{pix.payment_option.name}"
    fill_in 'Chave PIX', with: token
    select "#{bank.code} - #{bank.bank}", from: 'Código do banco'
    click_on 'Atualizar'
  
    expect(page).to have_content('já está em uso')
  end
end