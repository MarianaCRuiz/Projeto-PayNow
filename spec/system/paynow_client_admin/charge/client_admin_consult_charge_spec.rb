require 'rails_helper'  

describe 'client_admin consult charges' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                            city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                            address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:pay_boleto_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  let(:boleto) {BoletoRegisterOption.create!(company: company, payment_option: pay_boleto_1, 
                                            bank_code: bank, agency_number: '2050', 
                                            account_number: '123.555-8')}
  let(:product) {Product.create!(name:'Produto 1', price: 50, boleto_discount: 10, company: company)}
  let(:product_2) {Product.create!(name:'Produto 2', price: 60, boleto_discount: 10, company: company)}
  let(:final_client) {FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599')}
  let(:final_client_2) {FinalClient.create!(name: 'Cliente final 2', cpf: '11133355599')}
  let(:status_charge) {StatusCharge.create!(code: '01', description: 'Pendente de cobrança')}
  let(:charge_1) {Charge.create!(client_token: final_client.token, 
                                client_name: final_client.name, client_cpf: final_client.cpf, 
                                company_token:company.token, product_token: product.token, 
                                payment_method: pay_boleto_1.name, client_address: 'algum endereço', 
                                due_deadline: '24/12/2023', company: company, final_client: final_client,
                                status_charge: status_charge, product: product,
                                payment_option: pay_boleto_1, price: 50, charge_price: 45 )}
  let(:charge_11) {Charge.create!(client_token: final_client_2.token, 
                                client_name: final_client_2.name, client_cpf: final_client_2.cpf, 
                                company_token:company.token, product_token: product.token, 
                                payment_method: pay_boleto_1.name, client_address: 'algum endereço', 
                                due_deadline: '30/12/2024', company: company, final_client: final_client,
                                status_charge: status_charge, product: product_2,
                                payment_option: pay_boleto_1, price: 60, charge_price: 54)}

  it 'client_admin view charges status 01' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    PaymentCompany.create(company: company, payment_option: pay_boleto_1)
    HistoricProduct.create(product: product, company: company, price: product.price)
    HistoricProduct.create(product: product_2, company: company, price: product_2.price)

    boleto1 = boleto
    charge1 = charge_1
    charge2 = charge_11
    price1 = product.price
    price2 = product_2.price

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Consultar cobranças pendentes'
      
    expect(page).to have_content('Produto 1')
    expect(page).to have_content("45,00")
    expect(page).to have_content('Vencimento da fatura: 24/12/2023')
    expect(page).to have_content('Produto 2')
    expect(page).to have_content("54,00")
    expect(page).to have_content('Vencimento da fatura: 30/12/2024')
    expect(page).to have_content('Boleto')
  end
  it 'change charge status' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    PaymentCompany.create!(company: company, payment_option: pay_boleto_1)
    HistoricProduct.create!(product: product, company: company, price: product.price)
    HistoricProduct.create!(product: product_2, company: company, price: product_2.price)
    status_2 = StatusCharge.create!(code: "05", description: "Cobrança efetivada com sucesso")
    status1 = status_charge
    boleto1 = boleto
    charge1 = charge_1
    charge2 = charge_11
    price1 = product.price
    price2 = product_2.price

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Consultar cobranças pendentes'
    click_on "Atualizar Status: #{charge_1.token}"
    select "#{status_2.code} - #{status_2.description}", from: 'Status'
    fill_in 'Data efetiva do pagamento', with: '14/06/2021'
    fill_in 'Token de autorização', with: 'ncLc38dncjd93Nn'
    click_on 'Atualizar'

    expect(page).to_not have_content('Produto 1')
    expect(page).to_not have_content("45,00")
    expect(page).to_not have_content('Vencimento da fatura: 24/12/2023')
    expect(page).to have_content('Produto 2')
    expect(page).to have_content("54,00")
    expect(page).to have_content('Vencimento da fatura: 30/12/2024')
    expect(page).to have_content('Boleto')
    expect(Charge.first.status_charge.code).to eq('05')
  end
  it 'change charge status missing payment date' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    PaymentCompany.create!(company: company, payment_option: pay_boleto_1)
    CompanyClient.create!(final_client: final_client, company: company)
    CompanyClient.create!(final_client: final_client_2, company: company)
    HistoricProduct.create(product: product, company: company, price: product.price)
    HistoricProduct.create(product: product_2, company: company, price: product_2.price)
    status_2 = StatusCharge.create!(code: "05", description: "Cobrança efetivada com sucesso")
    boleto1 = boleto
    charge1 = charge_1
    charge2 = charge_11
    price1 = product.price
    price2 = product_2.price

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Consultar cobranças pendentes'
    click_on "Atualizar Status: #{charge_1.token}"
    select "#{status_2.code} - #{status_2.description}", from: 'Status'
    click_on 'Atualizar'

    expect(page).to have_content('não pode ficar em branco', count: 2)
  end
  it 'change charge status pendente' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    PaymentCompany.create!(company: company, payment_option: pay_boleto_1)
    HistoricProduct.create!(product: product, company: company, price: product.price)
    HistoricProduct.create!(product: product_2, company: company, price: product_2.price)
    status_2 = StatusCharge.create!(code: "11", description: "Cobrança recusada sem motivo especificado")
    boleto1 = boleto
    charge1 = charge_1
    charge2 = charge_11
    price1 = product.price
    price2 = product_2.price

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Consultar cobranças pendentes'
    click_on "Atualizar Status: #{charge_1.token}"
    select "#{status_2.code} - #{status_2.description}", from: 'Status'
    fill_in 'Data da tentativa de pagamento', with: '14/06/2021'
    click_on 'Atualizar'

    expect(page).to have_content('Produto 1')
    expect(page).to have_content("45,00")
    expect(page).to have_content('Vencimento da fatura: 24/12/2023')
    expect(page).to have_content('Cobrança recusada sem motivo especificado')
    expect(page).to have_content('Produto 2')
    expect(page).to have_content("54,00")
    expect(page).to have_content('Vencimento da fatura: 30/12/2024')
    expect(page).to have_content('Boleto')
    expect(Charge.first.status_charge.code).to eq('01')
  end
  it 'change charge status missing attempt payment date' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    PaymentCompany.create(company: company, payment_option: pay_boleto_1)
    HistoricProduct.create(product: product, company: company, price: product.price)
    HistoricProduct.create(product: product_2, company: company, price: product_2.price)
    CompanyClient.create!(final_client: final_client, company: company)
    CompanyClient.create!(final_client: final_client_2, company: company)
    boleto1 = boleto
    status = status_charge
    charge1 = charge_1
    charge2 = charge_11
    price1 = product.price
    price2 = product_2.price

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Consultar cobranças pendentes'
    click_on "Atualizar Status: #{charge_1.token}"
    select "#{status.code} - #{status.description}", from: 'Status'
    click_on 'Atualizar'

    expect(page).to have_content('não pode ficar em branco', count: 1)
  end
  it 'see all charges' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    PaymentCompany.create(company: company, payment_option: pay_boleto_1)
    HistoricProduct.create(product: product, company: company, price: product.price)
    HistoricProduct.create(product: product_2, company: company, price: product_2.price)
    CompanyClient.create!(final_client: final_client, company: company)
    CompanyClient.create!(final_client: final_client_2, company: company)
    status_2 = StatusCharge.create!(code: '05', description: "Cobrança efetivada com sucesso\n")
    boleto1 = boleto
    charge1 = charge_1
    charge_1.status_charge = status_2
    charge2 = charge_11
    price1 = product.price
    price2 = product_2.price
    
    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on "Consultar cobranças últimos 30 dias"
    click_on "Todas as cobranças"

    expect(page).to have_content('Produto 1')
    expect(page).to have_content("45,00")
    expect(page).to have_content('Vencimento da fatura: 24/12/2023')
    expect(page).to have_content('Produto 2')
    expect(page).to have_content("54,00")
    expect(page).to have_content('Vencimento da fatura: 30/12/2024')
    expect(page).to have_content('Boleto')
  end
  it 'see last 30 days charges' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    PaymentCompany.create(company: company, payment_option: pay_boleto_1)
    HistoricProduct.create(product: product, company: company, price: product.price)
    HistoricProduct.create(product: product_2, company: company, price: product_2.price)
    CompanyClient.create!(final_client: final_client, company: company)
    CompanyClient.create!(final_client: final_client_2, company: company)
    status_2 = StatusCharge.create!(code: '05', description: "Cobrança efetivada com sucesso\n")
    boleto1 = boleto
    charge1 = charge_1
    charge2 = charge_11
    price1 = product.price
    price2 = product_2.price
    
    a = charge_1
    b = a.created_at
    a.created_at = b - 10.days
    a.save!
    c = charge_11
    d = c.created_at
    c.created_at = d + 10.days
    c.save!

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on "Consultar cobranças últimos 30 dias"

    expect(page).to have_content('Produto 1')
    expect(page).to have_content("45,00")
    expect(page).to have_content('Vencimento da fatura: 24/12/2023')
    expect(page).to_not have_content('Produto 2')
    expect(page).to_not have_content("54,00")
    expect(page).to_not have_content('Vencimento da fatura: 30/12/2024')
    expect(page).to have_content('Boleto')
  end
  it 'see last 90 days charges' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    PaymentCompany.create(company: company, payment_option: pay_boleto_1)
    HistoricProduct.create(product: product, company: company, price: product.price)
    HistoricProduct.create(product: product_2, company: company, price: product_2.price)
    CompanyClient.create!(final_client: final_client, company: company)
    CompanyClient.create!(final_client: final_client_2, company: company)
    status_2 = StatusCharge.create!(code: '05', description: "Cobrança efetivada com sucesso\n")
    boleto1 = boleto
    charge1 = charge_1
    charge2 = charge_11
    price1 = product.price
    price2 = product_2.price
    
    a = charge_1
    b = a.created_at
    a.created_at = b - 10.days
    a.save!
    c = charge_11
    d = c.created_at
    c.created_at = d - 100.days
    c.save!

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on "Consultar cobranças últimos 30 dias"
    click_on "Últimos 90 dias"

    expect(page).to have_content('Produto 1')
    expect(page).to have_content("45,00")
    expect(page).to have_content('Vencimento da fatura: 24/12/2023')
    expect(page).to_not have_content('Produto 2')
    expect(page).to_not have_content("54,00")
    expect(page).to_not have_content('Vencimento da fatura: 30/12/2024')
    expect(page).to have_content('Boleto')
  end
end