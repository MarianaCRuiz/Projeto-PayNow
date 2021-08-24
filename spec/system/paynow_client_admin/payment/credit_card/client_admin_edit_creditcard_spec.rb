require 'rails_helper'

describe 'edit credit card option' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo',
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:pay_creditcard_1) {PaymentOption.create!(name: 'Cartão de Crédito PISA', fee: 1.9, max_money_fee: 20, payment_type: 1)}
  let(:creditcard) {CreditCardRegisterOption.create!(company: company, payment_option: pay_creditcard_1, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')}

  it 'client_admin edit credit card succesfully' do
    PaymentCompany.create(company: company, payment_option: pay_creditcard_1)
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    card = creditcard
    pay = pay_creditcard_1.name
    token = SecureRandom.base58(20)

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on "Atualizar #{pay}"
    fill_in 'Código operadora', with: token
    click_on 'Atualizar'

    expect(page).to have_content('Opção atualizada com sucesso')
    expect(page).to have_content(token)
    expect(page).to have_content('Cartão de Crédito PISA')
  end
  it 'cannot be blank' do
    PaymentCompany.create(company: company, payment_option: pay_creditcard_1)
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    card = creditcard
    pay = pay_creditcard_1.name
    token = SecureRandom.base58(20)

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on "Atualizar #{pay}"
    fill_in 'Código operadora', with: ''
    click_on 'Atualizar'

    expect(page).to have_content('não pode ficar em branco', count: 1)
  end
  it 'bank token uniq' do
    PaymentCompany.create(company: company, payment_option: pay_creditcard_1)
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    pay_new = PaymentOption.create!(name: 'MASTERCHEF', fee: 1.9, max_money_fee: 20)
    card = creditcard
    pay = pay_creditcard_1.name
    CreditCardRegisterOption.create!(payment_option: pay_new, company: company, credit_card_operator_token: 'haBN7S9kM726bhz5d1pB')

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on "Atualizar #{pay}"
    fill_in 'Código operadora', with: 'haBN7S9kM726bhz5d1pB'
    click_on 'Atualizar'

    expect(page).to have_content('já está em uso')
  end
end
