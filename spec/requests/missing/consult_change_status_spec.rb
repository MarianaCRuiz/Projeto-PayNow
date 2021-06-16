require 'rails_helper'

describe 'consult charges changing status api' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:product) {Product.create!(name:'Produto 1', price: 50, boleto_discount: 10, credit_card_discount: 8, company: company)}
  let(:pay_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  let(:boleto) {BoletoRegisterOption.create!(company: company, payment_option: pay_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')}
  let(:final_client) {FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599')}
  let(:status_charge) {StatusCharge.create!(code: '01', description: 'Pendente de cobrança')}
  let(:charge_1) {Charge.create!(client_token: final_client.token, 
                                  client_name: final_client.name, client_cpf: final_client.cpf, 
                                  company_token:company.token, product_token: product.token, 
                                  payment_method: pay_1.name, client_address: 'algum endereço', 
                                  due_deadline: '20/08/2021', company: company, final_client: final_client,
                                  status_charge: status_charge, product: product,
                                  payment_option: pay_1, price: product.price, charge_price: 45,
                                  product_name: product.name, discount: 5)}

  context 'change status' do
    it 'successfully' do
      CompanyClient.create!(final_client: final_client, company: company)
      HistoricProduct.create(product: product, company: company, price: product.price)
      PaymentCompany.create!(company: company, payment_option: pay_1)
      status_2 = StatusCharge.create!(code: "05", description: "Cobrança efetivada com sucesso")
      bank1 = bank
      boleto1 = boleto
      charge1 = charge_1

      get api_v1_company_consult_charges_path(company.token), params: {consult: {status_charge_id: status_2.id, charge_id: charge_1.token}}

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['client_name']).to eq('Cliente final 1')
      expect(parsed_body['client_cpf']).to eq('11122255599')
      expect(parsed_body['client_address']).to eq('algum endereço')
      expect(parsed_body['payment_method']).to eq('Boleto')
      expect(parsed_body['status_charge_id']).to eq(status_2.id)
    end
  end

  context 'failure' do
    it 'status invalid' do
      CompanyClient.create!(final_client: final_client, company: company)
      HistoricProduct.create(product: product, company: company, price: product.price)
      PaymentCompany.create!(company: company, payment_option: pay_1)
      status_2 = StatusCharge.create!(code: "05", description: "Cobrança efetivada com sucesso")
      bank1 = bank
      boleto1 = boleto
      charge1 = charge_1

      get api_v1_company_consult_charges_path(company.token), params: {consult: {status_charge_id: 10, charge_id: charge_1.token}}

      expect(response).to have_http_status(404)
    end
  end
end