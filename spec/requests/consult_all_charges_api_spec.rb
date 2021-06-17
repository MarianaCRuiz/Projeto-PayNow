require 'rails_helper'

describe 'consult charges api' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:product) {Product.create!(name:'Produto 1', price: 50, boleto_discount: 10, credit_card_discount: 8, company: company)}
  let(:product_2) {Product.create!(name:'Produto 2', price: 60, boleto_discount: 10, credit_card_discount: 5, company: company)}
  let(:pay_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:pay_2) {PaymentOption.create(name: 'Cartão de Crédito MasterChef', fee: 1.2, max_money_fee: 24, payment_type:1)}
  let(:pay_3) {PaymentOption.create(name: 'PIX', fee: 1.3, max_money_fee: 21, payment_type: 2)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  let(:boleto) {BoletoRegisterOption.create!(company: company, payment_option: pay_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')}
  let(:credit_card) {CreditCardRegisterOption.create!(company: company, payment_option: pay_2, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')}
  let(:pix) {PixRegisterOption.create!(company: company, payment_option: pay_3, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)}
  let(:final_client) {FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599')}
  let(:final_client_2) {FinalClient.create!(name: 'Cliente final 2', cpf: '11133355599')}
  let(:status_charge) {StatusCharge.create!(code: '01', description: 'Pendente de cobrança')}
  let(:charge_1) {Charge.create!(client_token: final_client.token, 
                                 client_name: final_client.name, client_cpf: final_client.cpf, 
                                 company_token:company.token, product_token: product.token, 
                                 payment_method: pay_1.name, client_address: 'algum endereço', 
                                 due_deadline: '20/08/2021', company: company, final_client: final_client,
                                 status_charge: status_charge, product: product,
                                 payment_option: pay_1, price: product.price, charge_price: 45,
                                 product_name: product.name, discount: 5)}
  let(:charge_11) {Charge.create!(client_token: final_client_2.token, 
                                 client_name: final_client_2.name, client_cpf: final_client_2.cpf, 
                                 company_token:company.token, product_token: product.token, 
                                 payment_method: pay_1.name, client_address: 'algum endereço', 
                                 due_deadline: '30/12/2022', company: company, final_client: final_client_2,
                                 status_charge: status_charge, product: product,
                                 payment_option: pay_1, price: product.price, charge_price: 45,
                                 product_name: product.name, discount: 5)}
  let(:charge_12) {Charge.create!(client_token: final_client_2.token, 
                                 client_name: final_client_2.name, client_cpf: final_client_2.cpf, 
                                 company_token:company.token, product_token: product_2.token, 
                                 payment_method: pay_2.name, card_number: '1111 2222 3333 4444', 
                                 card_name: 'CLIENTE X2', cvv_code: '123',
                                 due_deadline: '30/12/2023', company: company, final_client: final_client_2,
                                 status_charge: status_charge, product: product_2,
                                 payment_option: pay_2, price: product_2.price, charge_price: 57,
                                 product_name: product_2.name, discount: 3)}
   
  context 'all charges successfully' do
    it 'all charges' do
      CompanyClient.create!(final_client: final_client, company: company)
      CompanyClient.create!(final_client: final_client_2, company: company)
      HistoricProduct.create(product: product, company: company, price: product.price)
      HistoricProduct.create(product: product_2, company: company, price: product_2.price)
      PaymentCompany.create!(company: company, payment_option: pay_1)
      PaymentCompany.create!(company: company, payment_option: pay_2)
      bank1 = bank
      boleto1 = boleto
      credit_card1 = credit_card
      charge1 = charge_1
      charge2 = charge_11
      charge3 = charge_12

      get "/api/v1/consult_charges", params: {consult: {due_deadline: nil}, company_token: company.token}

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body.count).to eq(3)
      expect(parsed_body[0]['product_name']).to eq('Produto 1')
      expect(parsed_body[0]['price']).to eq('50.0')
      expect(parsed_body[0]['discount']).to eq('5.0')
      expect(parsed_body[0]['charge_price']).to eq('45.0')
      expect(parsed_body[0]['client_name']).to eq('Cliente final 1')
      expect(parsed_body[0]['client_cpf']).to eq('11122255599')
      expect(parsed_body[0]['payment_method']).to eq('Boleto')
      expect(parsed_body[1]['product_name']).to eq('Produto 1')
      expect(parsed_body[1]['price']).to eq('50.0')
      expect(parsed_body[1]['discount']).to eq('5.0')
      expect(parsed_body[1]['charge_price']).to eq('45.0')
      expect(parsed_body[1]['client_name']).to eq('Cliente final 2')
      expect(parsed_body[1]['client_cpf']).to eq('11133355599')
      expect(parsed_body[1]['payment_method']).to eq('Boleto')
      expect(parsed_body[2]['product_name']).to eq('Produto 2')
      expect(parsed_body[2]['price']).to eq('60.0')
      expect(parsed_body[2]['discount']).to eq('3.0')
      expect(parsed_body[2]['charge_price']).to eq('57.0')
      expect(parsed_body[2]['client_name']).to eq('Cliente final 2')
      expect(parsed_body[2]['client_cpf']).to eq('11133355599')
      expect(parsed_body[2]['payment_method']).to eq('Cartão de Crédito MasterChef')
    end
  end
  context 'failure' do
    it 'all charges' do
      company1 = company
  
      get "/api/v1/consult_charges", params: {consult: {due_deadline: nil}, company_token: company.token}

      expect(response).to have_http_status(204)
      expect(response.body).to be_empty 
    end
  end
end