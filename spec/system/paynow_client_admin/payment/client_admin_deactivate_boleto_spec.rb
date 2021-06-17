require 'rails_helper'

describe 'client_admin deactivate boleto' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:pay_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:pay_2) {PaymentOption.create!(name: 'Boleto 2', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}

  it 'successfuly' do
    DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
    BoletoRegisterOption.create!(company: company, payment_option: pay_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
    PaymentCompany.create!(company: company, payment_option: pay_1)

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Excluir Boleto'

    expect(page).to have_content('Meio de pagamento excluído com sucesso')
    expect(page).to_not have_content('001')
    expect(page).to_not have_content('2050')
    expect(page).to_not have_content('123.555-8')
  end
end