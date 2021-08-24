require 'rails_helper'

describe 'issuing recipes authomaticaly' do
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
  let(:final_client) {FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599')}
  let(:status_charge) {StatusCharge.create!(code: '01', description: 'Pendente de cobrança')}
  let(:charge_1) {Charge.create!(client_name: final_client.name, client_cpf: final_client.cpf,
                                 client_token: final_client.token, company_token:company.token,
                                 product_token: product.token, payment_method: pay_boleto_1.name,
                                 client_address: 'algum endereço', due_deadline: '24/12/2023',
                                 company: company, final_client: final_client,
                                 status_charge: status_charge, product: product,
                                 payment_option: pay_boleto_1, price: 50, charge_price: 45 )}

  it 'create receipts' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    PaymentCompany.create(company: company, payment_option: pay_boleto_1)
    HistoricProduct.create(product: product, company: company, price: product.price)
    CompanyClient.create!(company: company, final_client: final_client)
    status_2 = StatusCharge.create!(code: "05", description: "Cobrança efetivada com sucesso")
    boleto
    charge_1

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Consultar cobranças pendentes'
    click_on "Atualizar Status: #{charge_1.token}"
    select "#{status_2.code} - #{status_2.description}", from: 'Status'
    fill_in 'Data efetiva do pagamento', with: '14/06/2021'
    fill_in 'Token de autorização', with: 'ncLc38dncjd93Nn'
    click_on 'Atualizar'

    expect(page).to_not have_content('Produto 1')
    expect(page).to_not have_content("#{charge_1.charge_price}")
    expect(Receipt.count).to be(1)
  end
  it 'change charge status missing attempt payment date' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    PaymentCompany.create(company: company, payment_option: pay_boleto_1)
    HistoricProduct.create(product: product, company: company, price: product.price)
    CompanyClient.create!(company: company, final_client: final_client)
    boleto
    status = status_charge
    charge_1

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Consultar cobranças pendentes'
    click_on "Atualizar Status: #{charge_1.token}"
    select "#{status.code} - #{status.description}", from: 'Status'
    click_on 'Atualizar'

    expect(page).to have_content('não pode ficar em branco', count: 1)
    expect(Receipt.count).to be(0)
  end
end
