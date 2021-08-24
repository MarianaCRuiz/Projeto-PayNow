require 'rails_helper'

describe 'consult charges api' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:product) do
    Product.create!(name: 'Produto 1', price: 50, boleto_discount: 10, credit_card_discount: 8, company: company)
  end
  let(:product2) do
    Product.create!(name: 'Produto 2', price: 60, boleto_discount: 10, credit_card_discount: 5, company: company)
  end
  let(:pay_boleto1) { PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0) }
  let(:pay_creditcard1) do
    PaymentOption.create(name: 'Cartão de Crédito MasterChef', fee: 1.2, max_money_fee: 24, payment_type: 1)
  end
  let(:pay_pix1) { PaymentOption.create(name: 'PIX', fee: 1.3, max_money_fee: 21, payment_type: 2) }
  let(:bank) { BankCode.create!(code: '001', bank: 'Banco do Brasil S.A.') }
  let(:boleto) do
    BoletoRegisterOption.create!(company: company, payment_option: pay_boleto1, bank_code: bank, agency_number: '2050',
                                 account_number: '123.555-8')
  end
  let(:credit_card) do
    CreditCardRegisterOption.create!(company: company, payment_option: pay_creditcard1,
                                     credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
  end
  let(:pix) do
    PixRegisterOption.create!(company: company, payment_option: pay_pix1, pix_key: 'AJ86gt4fLBtcF296rTuN',
                              bank_code: bank)
  end
  let(:final_client) { FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599') }
  let(:final_client2) { FinalClient.create!(name: 'Cliente final 2', cpf: '11133355599') }
  let(:status_charge) { StatusCharge.create!(code: '01', description: 'Pendente de cobrança') }
  let(:charge1) do
    Charge.create!(client_token: final_client.token,
                   client_name: final_client.name, client_cpf: final_client.cpf,
                   company_token: company.token, product_token: product.token,
                   payment_method: pay_boleto1.name, client_address: 'algum endereço',
                   due_deadline: '20/08/2021', company: company, final_client: final_client,
                   status_charge: status_charge, product: product,
                   payment_option: pay_boleto1, price: product.price, charge_price: 45,
                   product_name: product.name, discount: 5)
  end
  let(:charge11) do
    Charge.create!(client_token: final_client2.token,
                   client_name: final_client2.name, client_cpf: final_client2.cpf,
                   company_token: company.token, product_token: product.token,
                   payment_method: pay_boleto1.name, client_address: 'algum endereço',
                   due_deadline: '30/12/2022', company: company, final_client: final_client2,
                   status_charge: status_charge, product: product,
                   payment_option: pay_boleto1, price: product.price, charge_price: 45,
                   product_name: product.name, discount: 5)
  end
  let(:charge12) do
    Charge.create!(client_token: final_client2.token,
                   client_name: final_client2.name, client_cpf: final_client2.cpf,
                   company_token: company.token, product_token: product2.token,
                   payment_method: pay_creditcard1.name, card_number: '1111 2222 3333 4444',
                   card_name: 'CLIENTE X2', cvv_code: '123',
                   due_deadline: '30/12/2023', company: company, final_client: final_client2,
                   status_charge: status_charge, product: product2,
                   payment_option: pay_creditcard1, price: product2.price, charge_price: 57,
                   product_name: product2.name, discount: 3)
  end

  context 'all charges successfully' do
    it 'all charges' do
      CompanyClient.create!(final_client: final_client, company: company)
      CompanyClient.create!(final_client: final_client2, company: company)
      product
      product2
      PaymentCompany.create!(company: company, payment_option: pay_boleto1)
      PaymentCompany.create!(company: company, payment_option: pay_creditcard1)
      bank
      boleto
      credit_card
      charge1
      charge11
      charge12

      get '/api/v1/consult_charges', params: { consult: { due_deadline: nil }, company_token: company.token }

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
      company

      get '/api/v1/consult_charges', params: { consult: { due_deadline: nil }, company_token: company.token }

      expect(response).to have_http_status(204)
      expect(response.body).to be_empty
    end

    it 'no params' do
      company

      get '/api/v1/consult_charges', params: { consult: {}, company_token: company.token }

      expect(response).to have_http_status(412)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['errors']).to eq('parâmetros inválidos')
    end
  end
end
