require 'rails_helper'

describe 'admin consult charges' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:pay_boleto1) { PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0) }
  let(:bank) { BankCode.create!(code: '001', bank: 'Banco do Brasil S.A.') }
  let(:boleto) do
    BoletoRegisterOption.create!(company: company, payment_option: pay_boleto1,
                                 bank_code: bank, agency_number: '2050',
                                 account_number: '123.555-8')
  end
  let(:product) { Product.create!(name: 'Produto 1', price: 50, boleto_discount: 10, company: company) }
  let(:product2) { Product.create!(name: 'Produto 2', price: 60, boleto_discount: 10, company: company) }
  let(:final_client) { FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599') }
  let(:final_client2) { FinalClient.create!(name: 'Cliente final 2', cpf: '11133355599') }
  let(:status_charge) { StatusCharge.create!(code: '01', description: 'Pendente de cobrança') }
  let(:charge1) do
    Charge.create!(client_token: final_client.token,
                   client_name: final_client.name, client_cpf: final_client.cpf,
                   company_token: company.token, product_token: product.token,
                   payment_method: pay_boleto1.name, client_address: 'algum endereço',
                   due_deadline: '24/12/2023', company: company, final_client: final_client,
                   status_charge: status_charge, product: product,
                   payment_option: pay_boleto1, price: 50, charge_price: 45)
  end
  let(:charge11) do
    Charge.create!(client_token: final_client2.token,
                   client_name: final_client2.name, client_cpf: final_client2.cpf,
                   company_token: company.token, product_token: product.token,
                   payment_method: pay_boleto1.name, client_address: 'algum endereço',
                   due_deadline: '30/12/2024', company: company, final_client: final_client,
                   status_charge: status_charge, product: product2,
                   payment_option: pay_boleto1, price: 60, charge_price: 54)
  end

  it 'admin view charges status 01' do
    Admin.create!(email: 'admin@paynow.com.br')
    Admin.create!(email: 'admin2@paynow.com.br')
    admin = User.create!(email: 'admin@paynow.com.br', password: '123456', role: 2)
    PaymentCompany.create!(company: company, payment_option: pay_boleto1)
    product
    product2
    boleto
    charge1
    charge11

    login_as admin, scope: :user
    visit root_path
    click_on 'Empresas cadastradas'
    click_on 'Codeplay SA'
    click_on 'Consultar cobranças pendentes'

    expect(page).to have_content('Produto 1')
    expect(page).to have_content('45,00')
    expect(page).to have_content('Vencimento da fatura: 24/12/2023')
    expect(page).to have_content('Produto 2')
    expect(page).to have_content('54,00')
    expect(page).to have_content('Vencimento da fatura: 30/12/2024')
    expect(page).to have_content('Boleto')
  end
  it 'change charge status' do
    Admin.create!(email: 'admin@paynow.com.br')
    admin = User.create!(email: 'admin@paynow.com.br', password: '123456', role: 2)
    PaymentCompany.create!(company: company, payment_option: pay_boleto1)
    product
    product2
    status2 = StatusCharge.create!(code: '05', description: 'Cobrança efetivada com sucesso')
    boleto
    charge1
    charge11

    login_as admin, scope: :user
    visit admin_company_path(company.token)
    click_on 'Consultar cobranças pendentes'
    click_on "Atualizar Status: #{charge1.token}"
    select "#{status2.code} - #{status2.description}", from: 'Status'
    fill_in 'Data efetiva do pagamento', with: '14/06/2021'
    fill_in 'Token de autorização', with: 'ncLc38dncjd93Nn'
    click_on 'Atualizar'

    expect(page).to_not have_content('Produto 1')
    expect(page).to_not have_content('45,00')
    expect(page).to_not have_content('Vencimento da fatura: 24/12/2023')
    expect(page).to have_content('Produto 2')
    expect(page).to have_content('54,00')
    expect(page).to have_content('Vencimento da fatura: 30/12/2024')
    expect(page).to have_content('Boleto')
    expect(Charge.first.status_charge.code).to eq('05')
  end
  it 'change charge status missing payment date' do
    Admin.create!(email: 'admin@paynow.com.br')
    admin = User.create!(email: 'admin@paynow.com.br', password: '123456', role: 2)
    PaymentCompany.create!(company: company, payment_option: pay_boleto1)
    CompanyClient.create!(final_client: final_client, company: company)
    CompanyClient.create!(final_client: final_client2, company: company)
    product
    product2
    status2 = StatusCharge.create!(code: '05', description: 'Cobrança efetivada com sucesso')
    boleto
    charge1
    charge11

    login_as admin, scope: :user
    visit admin_company_path(company[:token])
    click_on 'Consultar cobranças pendentes'
    click_on "Atualizar Status: #{charge1.token}"
    select "#{status2.code} - #{status2.description}", from: 'Status'
    click_on 'Atualizar'

    expect(page).to have_content('não pode ficar em branco', count: 2)
  end
  it 'change charge status pendente' do
    Admin.create!(email: 'admin@paynow.com.br')
    admin = User.create!(email: 'admin@paynow.com.br', password: '123456', role: 2)
    PaymentCompany.create!(company: company, payment_option: pay_boleto1)
    product
    product2
    status2 = StatusCharge.create!(code: '11', description: 'Cobrança recusada sem motivo especificado')
    boleto
    charge1
    charge11

    login_as admin, scope: :user
    visit admin_company_path(company[:token])
    click_on 'Consultar cobranças pendentes'
    click_on "Atualizar Status: #{charge1.token}"
    select "#{status2.code} - #{status2.description}", from: 'Status'
    fill_in 'Data da tentativa de pagamento', with: '14/06/2021'
    click_on 'Atualizar'

    expect(page).to have_content('Produto 1')
    expect(page).to have_content('45,00')
    expect(page).to have_content('Vencimento da fatura: 24/12/2023')
    expect(page).to have_content('Cobrança recusada sem motivo especificado')
    expect(page).to have_content('Produto 2')
    expect(page).to have_content('54,00')
    expect(page).to have_content('Vencimento da fatura: 30/12/2024')
    expect(page).to have_content('Boleto')
    expect(Charge.first.status_charge.code).to eq('01')
  end
  it 'change charge status missing attempt payment date' do
    Admin.create!(email: 'admin@paynow.com.br')
    admin = User.create!(email: 'admin@paynow.com.br', password: '123456', role: 2)
    PaymentCompany.create!(company: company, payment_option: pay_boleto1)
    product
    product2
    CompanyClient.create!(final_client: final_client, company: company)
    CompanyClient.create!(final_client: final_client2, company: company)
    boleto
    status = status_charge
    charge1
    charge11

    login_as admin, scope: :user
    visit admin_company_path(company[:token])
    click_on 'Consultar cobranças pendentes'
    click_on "Atualizar Status: #{charge1.token}"
    select "#{status.code} - #{status.description}", from: 'Status'
    click_on 'Atualizar'

    expect(page).to have_content('não pode ficar em branco', count: 1)
  end
  it 'see all charges' do
    Admin.create!(email: 'admin@paynow.com.br')
    admin = User.create!(email: 'admin@paynow.com.br', password: '123456', role: 2)
    PaymentCompany.create!(company: company, payment_option: pay_boleto1)
    product
    product2
    CompanyClient.create!(final_client: final_client, company: company)
    CompanyClient.create!(final_client: final_client2, company: company)
    status2 = StatusCharge.create!(code: '05', description: "Cobrança efetivada com sucesso\n")
    boleto
    charge1
    charge1.status_charge = status2
    charge11

    login_as admin, scope: :user
    visit admin_company_path(company[:token])
    click_on 'Consultar todas as cobranças'

    expect(page).to have_content('Produto 1')
    expect(page).to have_content('45,00')
    expect(page).to have_content('Vencimento da fatura: 24/12/2023')
    expect(page).to have_content('Produto 2')
    expect(page).to have_content('54,00')
    expect(page).to have_content('Vencimento da fatura: 30/12/2024')
    expect(page).to have_content('Boleto')
  end
end
