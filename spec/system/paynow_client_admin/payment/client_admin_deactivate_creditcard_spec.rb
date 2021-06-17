require 'rails_helper'

describe 'client_admin deactivate credit card option' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:pay_2) {PaymentOption.create!(name: 'Cartão de Crédito PISA', fee: 1.9, max_money_fee: 20, payment_type: 1)}
  let(:creditcard) {CreditCardRegisterOption.create!(company: company, payment_option: pay_2, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')}
  
  it 'client_admin deactivate credit card succesfully' do
    PaymentCompany.create(company: company, payment_option: pay_2)
    DomainRecord.create!(email_client_admin: user_admin, domain: 'empresa3.com', company: company)
    card = creditcard
    pay = pay_2.name
    

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on "Excluir #{pay}"

    expect(page).to have_content('Meio de pagamento excluído com sucesso')  
    expect(page).to_not have_content(creditcard.credit_card_operator_token)
    #expect(page).to_not have_content('Cartão de Crédito PISA')
  end
end