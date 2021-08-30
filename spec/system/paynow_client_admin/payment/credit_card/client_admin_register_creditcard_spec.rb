require 'rails_helper'

describe 'register credit card option' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:user_admin) { User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company) }
  let(:pay_creditcard1) do
    PaymentOption.create!(name: 'Cartão de Crédito MASTERCHEF', fee: 1.9, max_money_fee: 20, payment_type: 1)
  end

  it 'client_admin register credit card succesfully' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    pay = pay_creditcard1
    token = SecureRandom.base58(20)

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento'
    click_on "Adicionar: #{pay.name}"
    fill_in 'Código operadora', with: token
    click_on 'Registrar cartão'

    expect(page).to have_content('Opção adicionada com sucesso')
    expect(page).to have_content(token)
    expect(page).to have_content('Cartão de Crédito MASTERCHEF')
  end
  it 'cannot be blank' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    pay = pay_creditcard1

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento'
    click_on "Adicionar: #{pay.name}"
    fill_in 'Código operadora', with: ''
    click_on 'Registrar cartão'

    expect(page).to have_content('não pode ficar em branco', count: 1)
  end
  it 'bank token uniq' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    pay = pay_creditcard1
    CreditCardRegisterOption.create!(payment_option: pay_creditcard1, company: company,
                                     credit_card_operator_token: 'haBN7S9kM726bhz5d1pB')

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento'
    click_on "Adicionar: #{pay.name}"
    fill_in 'Código operadora', with: 'haBN7S9kM726bhz5d1pB'
    click_on 'Registrar cartão'

    expect(page).to have_content('já está em uso')
  end
end
