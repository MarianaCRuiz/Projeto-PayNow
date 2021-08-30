require 'rails_helper'

describe 'register PIX option' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:user_admin) { User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company) }
  let(:pay_creditcard1) do
    PaymentOption.create!(name: 'Cartão de Crédito PISA', fee: 1.9, max_money_fee: 20, payment_type: 1)
  end
  let(:pay_boleto1) { PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0) }
  let(:pay_pix1) { PaymentOption.create!(name: 'pix1', fee: 1.9, max_money_fee: 20, payment_type: 2) }
  let(:bank) { BankCode.create!(code: '001', bank: 'Banco do Brasil S.A.') }
  let(:boleto) do
    BoletoRegisterOption.create!(company: company, payment_option: pay_boleto1, bank_code: bank, agency_number: '2050',
                                 account_number: '123.555-8')
  end
  let(:creditcard) do
    CreditCardRegisterOption.create!(company: company, payment_option: pay_creditcard1,
                                     credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
  end
  let(:pix_option) do
    PixRegisterOption.create!(company: company, payment_option: pay_pix1, pix_key: 'AJ86gt4fLBtcF296rTuN',
                              bank_code: bank)
  end

  it 'client_admin view payment chosen' do
    PaymentCompany.create!(company: company, payment_option: pay_boleto1)
    PaymentCompany.create!(company: company, payment_option: pay_creditcard1)
    PaymentCompany.create!(company: company, payment_option: pay_pix1)
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    bank
    pay_boleto1
    pay_creditcard1
    pay_pix1
    boleto
    creditcard
    pix_option

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'

    expect(page).to have_content('Boleto')
    expect(page).to have_content('2050')
    expect(page).to have_content('123.555-8')
    expect(page).to have_content('Cartão de Crédito PISA')
    expect(page).to have_content('jdB8SD923Nmg8fR1GhJm')
    expect(page).to have_content('pix1')
    expect(page).to have_content('AJ86gt4fLBtcF296rTuN')
  end
end
