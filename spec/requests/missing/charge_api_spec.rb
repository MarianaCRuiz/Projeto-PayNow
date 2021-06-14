require 'rails_helper'

describe 'charge api' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:product) {Product.create!(name:'Produto 1', price: 50, boleto_discount: 10, credit_card_discount: 8, company: company)}
  let(:pay_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:pay_2) {PaymentOption.create(name: 'Cartão de Crédito MasterChef', fee: 1.2, max_money_fee: 24, payment_type:1)}
  let(:pay_3) {PaymentOption.create(name: 'PIX', fee: 1.3, max_money_fee: 21, payment_type: 2)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  let(:boleto) {BoletoRegisterOption.create!(company: company, payment_option: pay_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')}
  let(:creditcard) {CreditCardRegisterOption.create!(company: company, payment_option: pay_2, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')}
  let(:pix_option) {PixRegisterOption.create!(company: company, payment_option: pay_3, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)}
  let(:final_client) {FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599')}
  context 'POST charge api' do
    context 'generating charge successfully' do
      it 'boleto' do
        CompanyClient.create!(final_client: final_client, company: company)
        product1 = product
        bank1 = bank
        pay1 = pay_1
        boleto1 = boleto
        HistoricProduct.create(product: product, company: company, price: product.price)

        post "/api/v1/companies/#{company.token}/charges", params: {charge: {client_name: final_client.name, client_cpf: final_client.cpf, 
            company_token: company.token, product_token: product.token, boleto_register_option_id: boleto.id, 
            client_address: 'Rua 1, numero 2, Bairro X, Cidade 1, Estado Y',
            due_deadline: '24/12/2023'}}

        expect(response).to have_http_status(201)
        expect(response.content_type).to include('application/json')
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['product_name']).to eq('Produto 1')
        expect(parsed_body['price']).to eq('50.0')
        expect(parsed_body['discount']).to eq('5.0')
        expect(parsed_body['charge_price']).to eq('45.0')
        expect(parsed_body['client_name']).to eq('Cliente final 1')
        expect(parsed_body['client_cpf']).to eq('11122255599')
        expect(parsed_body['payment_method']).to eq('Boleto')
      end
      it 'credit card' do
        CompanyClient.create!(final_client: final_client, company: company)
        product1 = product
        bank1 = bank
        pay1 = pay_2
        credit_card1 = credit_card
        HistoricProduct.create(product: product, company: company, price: product.price)

        post "/api/v1/companies/#{company.token}/charges", params: {charge: {client_name: final_client.name, client_cpf: final_client.cpf, 
            company_token: company.token, product_token: product.token, boleto_register_option_id: boleto.id, 
            client_address: 'Rua 1, numero 2, Bairro X, Cidade 1, Estado Y',
            due_deadline: '24/12/2023'}}

        expect(response).to have_http_status(201)
        expect(response.content_type).to include('application/json')
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['product_name']).to eq('Produto 1')
        expect(parsed_body['price']).to eq('50.0')
        expect(parsed_body['discount']).to eq('5.0')
        expect(parsed_body['charge_price']).to eq('45.0')
        expect(parsed_body['client_name']).to eq('Cliente final 1')
        expect(parsed_body['client_cpf']).to eq('11122255599')
        expect(parsed_body['payment_method']).to eq('Boleto')
      end
    end
    it 'missing payment method' do
      company1 = company
      product1 = product
      bank1 = bank
      pay1 = pay
      boleto1 = boleto
      final_client1 = final_client
      HistoricProduct.create(product: product, company: company, price: product.price)

      post "/api/v1/companies/#{company.token}/charges", params: {charge: {client_name: final_client.name, client_cpf: final_client.cpf, 
        company_token: company.token, product_token: product.token, 
        client_address: 'Rua 1, numero 2, Bairro X, Cidade 1, Estado Y',
        due_deadline: '24/12/2023'}}

      expect(response).to have_http_status(412)
      
    end
    xit 'params must be uniq' do
      
    end
  end
end