require 'rails_helper'

describe 'consult charges api' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:product) {Product.create!(name:'Produto 1', price: 50, boleto_discount: 10, credit_card_discount: 8, company: company)}
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
                                 due_deadline: '30/12/2024', company: company, final_client: final_client_2,
                                 status_charge: status_charge, product: product,
                                 payment_option: pay_1, price: product.price, charge_price: 45,
                                 product_name: product.name, discount: 5)}
  context 'GET consult charges api' do
    context 'all charges successfully' do
      it 'all charges' do
        CompanyClient.create!(final_client: final_client, company: company)
        CompanyClient.create!(final_client: final_client_2, company: company)
        HistoricProduct.create(product: product, company: company, price: product.price)
        PaymentCompany.create!(company: company, payment_option: pay_1)
        bank1 = bank
        boleto1 = boleto
        charge1 = charge_1
        charge2 = charge_11

        get api_v1_company_consult_charges_path(company.token)

        expect(response).to have_http_status(200)
        expect(response.content_type).to include('application/json')
        parsed_body = JSON.parse(response.body)
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
      end
      it 'filter due deadline specific' do
        CompanyClient.create!(final_client: final_client, company: company)
        CompanyClient.create!(final_client: final_client_2, company: company)
        HistoricProduct.create(product: product, company: company, price: product.price)
        PaymentCompany.create!(company: company, payment_option: pay_1)
        bank1 = bank
        boleto1 = boleto
        charge1 = charge_1
        charge2 = charge_11

        get api_v1_company_consult_charges_path(company.token), params: {due_deadline: '20/08/2021'}


        expect(response).to have_http_status(200)
        expect(response.content_type).to include('application/json')
        parsed_body = JSON.parse(response.body)
        expect(parsed_body[0]['product_name']).to eq('Produto 1')
        expect(parsed_body[0]['price']).to eq('50.0')
        expect(parsed_body[0]['discount']).to eq('5.0')
        expect(parsed_body[0]['charge_price']).to eq('45.0')
        expect(parsed_body[0]['client_name']).to eq('Cliente final 1')
        expect(parsed_body[0]['client_cpf']).to eq('11122255599')
        expect(parsed_body[0]['payment_method']).to eq('Boleto')
      end
      xit 'filter due deadline max' do
        CompanyClient.create!(final_client: final_client, company: company)
        CompanyClient.create!(final_client: final_client_2, company: company)
        HistoricProduct.create(product: product, company: company, price: product.price)
        PaymentCompany.create!(company: company, payment_option: pay_1)
        bank1 = bank
        boleto1 = boleto
        charge1 = charge_1
        charge2 = charge_11

        get api_v1_company_consult_charges_path(company.token), params: {due_deadline_max: '20/09/2021'}


        expect(response).to have_http_status(200)
        expect(response.content_type).to include('application/json')
        parsed_body = JSON.parse(response.body)
        byebug
        expect(parsed_body[0]['product_name']).to eq('Produto 1')
        expect(parsed_body[0]['price']).to eq('50.0')
        expect(parsed_body[0]['discount']).to eq('5.0')
        expect(parsed_body[0]['charge_price']).to eq('45.0')
        expect(parsed_body[0]['client_name']).to eq('Cliente final 1')
        expect(parsed_body[0]['client_cpf']).to eq('11122255599')
        expect(parsed_body[0]['payment_method']).to eq('Boleto')
      end
    end
    context 'failure' do
      xit 'missing payment method' do
        CompanyClient.create!(final_client: final_client, company: company)
        CompanyClient.create!(final_client: final_client_2, company: company)
        HistoricProduct.create!(product: product, company: company, price: product.price)
        bank1 = bank
        pay1 = pay_1
        boleto1 = boleto
        final_client1 = final_client
        
        
        post "/api/v1/charges", params: {charge: {client_token: final_client.token, 
            company_token: company.token, product_token: product.token, 
            client_address: 'Rua 1, numero 2, Bairro X, Cidade 1, Estado Y',
            due_deadline: '24/12/2023'}}

        expect(response).to have_http_status(412)
      end
      xit 'final client params must be present' do
        CompanyClient.create!(final_client: final_client, company: company)
        CompanyClient.create!(final_client: final_client_2, company: company)
        HistoricProduct.create!(product: product, company: company, price: product.price)
        company1 = company
        product1 = product
        bank1 = bank
        pay1 = pay_1
        boleto1 = boleto
        final_client1 = final_client

        post "/api/v1/charges", params: {charge: {company_token: company.token, product_token: product.token, payment_method: pay_1.name, 
            client_address: 'Rua 1, numero 2, Bairro X, Cidade 1, Estado Y',
            due_deadline: '24/12/2023'}}

        expect(response).to have_http_status(412)
      end
      xit 'company and product params must be present' do
        CompanyClient.create!(final_client: final_client, company: company)
        CompanyClient.create!(final_client: final_client_2, company: company)
        HistoricProduct.create!(product: product, company: company, price: product.price)
        company1 = company
        product1 = product
        bank1 = bank
        pay1 = pay_1
        boleto1 = boleto
        final_client1 = final_client

        post "/api/v1/charges", params: {charge: {client_token: final_client.token, payment_method: pay_1.name, 
            client_address: 'Rua 1, numero 2, Bairro X, Cidade 1, Estado Y',
            due_deadline: '24/12/2023'}}

        expect(response).to have_http_status(412)
      end
    end
  end
end