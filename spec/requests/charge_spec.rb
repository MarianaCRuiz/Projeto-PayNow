require 'rails_helper'

describe 'authentication' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:user) {User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company)}    
  let(:pay_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  let(:boleto) {BoletoRegisterOption.create!(company: company, payment_option: pay_1, 
                                            bank_code: bank, agency_number: '2050', 
                                            account_number: '123.555-8')}
  let(:product) {Product.create!(name:'Produto 1', price: 50, boleto_discount: 10, company: company)}
  let(:product_2) {Product.create!(name:'Produto 2', price: 60, boleto_discount: 10, company: company)}
  let(:final_client) {FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599')}
  let(:status_charge) {StatusCharge.create!(code: '01', description: 'Pendente de cobrança')}
  let(:charge) {Charge.create!(client_token: final_client.token, client_name: 'Cliente 1', client_cpf: '11133355588', 
                                company_token:company.token, product_token: product.token, 
                                payment_method: pay_1.name, client_address: 'algum endereço', 
                                due_deadline: '24/12/2023', company: company, final_client: final_client,
                                status_charge: status_charge, product: product,
                                payment_option: pay_1, price: 50, charge_price: 45 )}

  context 'client_admin controller' do
    context 'visitor' do
      it 'PATCH' do
        PaymentCompany.create(company: company, payment_option: pay_1)
        HistoricProduct.create(product: product, company: company, price: product.price)
        company_1 = company
        charge1 = charge
        final_client1 = final_client
        patch client_admin_charge_path(charge.token)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context 'client' do
      it 'PATCH' do
        PaymentCompany.create(company: company, payment_option: pay_1)
        HistoricProduct.create(product: product, company: company, price: product.price)
        DomainRecord.create!(email_client_admin: user_admin.email, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user.email, domain: 'codeplay.com', company: company)
        company_1 = company
        final_client1 = final_client

        login_as user, scope: :user
        patch client_admin_charge_path(charge.token)
              
        expect(response).to redirect_to(root_path)
      end
    end
  end
end       