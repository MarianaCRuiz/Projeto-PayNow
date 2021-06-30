require 'rails_helper'

describe 'client_admin deactivate boleto' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:pay_boleto_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:pay_creditcard_1) {PaymentOption.create!(name: 'Boleto 2', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  let(:bank_2) {BankCode.create!(code: '029', bank:'Itaú')}
  let(:product) {Product.create!(name:'Produto 1', price: 50, boleto_discount: 10, company: company)}
  let(:final_client) {FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599')}
  let(:status_charge) {StatusCharge.create!(code: '01', description: 'Pendente de cobrança')}

  it 'successfuly' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    boleto = BoletoRegisterOption.create!(company: company, payment_option: pay_boleto_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
    BoletoRegisterOption.create!(company: company, payment_option: pay_creditcard_1, bank_code: bank_2, agency_number: '4030', account_number: '123.444-9')
    PaymentCompany.create!(company: company, payment_option: pay_boleto_1)
    PaymentCompany.create!(company: company, payment_option: pay_creditcard_1)
    Charge.create!(client_token: final_client.token, client_name: final_client.name, client_cpf: final_client.cpf, 
                   company_token:company.token, product_token: product.token, 
                   payment_method: pay_boleto_1.name, client_address: 'algum endereço', 
                   due_deadline: '24/12/2023', company: company, final_client: final_client,
                   status_charge: status_charge, product: product, boleto_register_option: boleto,
                   payment_option: pay_boleto_1, price: 50, charge_price: 45 )

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Excluir Boleto'

    expect(page).to have_content('Meio de pagamento excluído com sucesso')
    expect(page).to_not have_content('001')
    expect(page).to_not have_content('2050')
    expect(page).to_not have_content('123.555-8')
    expect(page).to have_content('029')
    expect(page).to have_content('4030')
    expect(page).to have_content('123.444-9')
  end
end