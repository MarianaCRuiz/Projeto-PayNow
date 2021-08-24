require 'rails_helper'

describe 'charge api' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:product) do
    Product.create!(name: 'Produto 1', price: 50, boleto_discount: 10, credit_card_discount: 8, company: company)
  end
  let(:pay_boleto1) { PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0) }
  let(:pay_creditcard1) do
    PaymentOption.create(name: 'Cartão de Crédito MasterChef', fee: 1.2, max_money_fee: 24, payment_type: 1)
  end
  let(:pay_pix1) { PaymentOption.create(name: 'PIX', fee: 1.3, max_money_fee: 21, payment_type: 2) }
  let(:bank) { BankCode.create!(code: '001', bank: 'Banco do Brasil S.A.') }
  let(:boleto) do
    BoletoRegisterOption.create!(company: company, payment_option: pay_boleto1, bank_code: bank,
                                 agency_number: '2050', account_number: '123.555-8')
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
  context 'POST charge api' do
    context 'generating charge successfully' do
      it 'boleto' do
        CompanyClient.create!(final_client: final_client, company: company)
        product
        bank
        pay_boleto1
        boleto
        PaymentCompany.create!(company: company, payment_option: pay_boleto1)

        post '/api/v1/charges', params: { charge: { client_token: final_client.token,
                                                    company_token: company.token, product_token: product.token,
                                                    payment_method: pay_boleto1.name,
                                                    client_address: 'Rua 1, numero 2, Bairro X, Cidade 1, Estado Y',
                                                    due_deadline: '24/12/2023' } }

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
        product
        bank
        pay_creditcard1
        credit_card

        post '/api/v1/charges', params: { charge: { client_token: final_client.token,
                                                    company_token: company.token, product_token: product.token,
                                                    payment_method: pay_creditcard1.name,
                                                    card_number: '1111 2222 333 4444', card_name: 'FULANO A C',
                                                    cvv_code: '444' } }

        expect(response).to have_http_status(201)
        expect(response.content_type).to include('application/json')
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['product_name']).to eq('Produto 1')
        expect(parsed_body['price']).to eq('50.0')
        expect(parsed_body['discount']).to eq('4.0')
        expect(parsed_body['charge_price']).to eq('46.0')
        expect(parsed_body['client_name']).to eq('Cliente final 1')
        expect(parsed_body['client_cpf']).to eq('11122255599')
        expect(parsed_body['payment_method']).to eq('Cartão de Crédito MasterChef')
      end
      it 'pix' do
        CompanyClient.create!(final_client: final_client, company: company)
        product
        bank
        pay_pix1
        pix

        post '/api/v1/charges', params: { charge: { client_token: final_client.token,
                                                    company_token: company.token,
                                                    product_token: product.token,
                                                    payment_method: pay_pix1.name } }

        expect(response).to have_http_status(201)
        expect(response.content_type).to include('application/json')
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['product_name']).to eq('Produto 1')
        expect(parsed_body['price']).to eq('50.0')
        expect(parsed_body['discount']).to eq('0.0')
        expect(parsed_body['charge_price']).to eq('50.0')
        expect(parsed_body['client_name']).to eq('Cliente final 1')
        expect(parsed_body['client_cpf']).to eq('11122255599')
        expect(parsed_body['payment_method']).to eq('PIX')
      end
    end
    context 'failure' do
      it 'missing payment method' do
        company
        product
        bank
        pay_boleto1
        boleto
        final_client

        post '/api/v1/charges', params: { charge: { client_token: final_client.token,
                                                    company_token: company.token, product_token: product.token,
                                                    client_address: 'Rua 1, numero 2, Bairro X, Cidade 1, Estado Y',
                                                    due_deadline: '24/12/2023' } }

        expect(response).to have_http_status(412)
      end
      it 'final client params must be present' do
        company
        product
        bank
        pay_boleto1
        boleto
        final_client

        post '/api/v1/charges', params: { charge: { company_token: company.token, product_token: product.token,
                                                    payment_method: pay_boleto1.name,
                                                    client_address: 'Rua 1, numero 2, Bairro X, Cidade 1, Estado Y',
                                                    due_deadline: '24/12/2023' } }

        expect(response).to have_http_status(412)
      end
      it 'company and product params must be present' do
        company
        product
        bank
        pay_boleto1
        boleto
        final_client

        post '/api/v1/charges', params: { charge: { client_token: final_client.token, payment_method: pay_boleto1.name,
                                                    client_address: 'Rua 1, numero 2, Bairro X, Cidade 1, Estado Y',
                                                    due_deadline: '24/12/2023' } }

        expect(response).to have_http_status(412)
      end
      it 'no params' do
        company
        product
        bank
        pay_boleto1
        boleto
        final_client

        post '/api/v1/charges', params: { charge: {} }

        expect(response).to have_http_status(412)
        expect(response.content_type).to include('application/json')
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['errors']).to eq('parâmetros inválidos')
      end
      it 'company cannot issue charges' do
        product
        pay_boleto1
        bank
        boleto
        final_client
        message = 'Não foi possível gerar a cobrança, a conta da empresa na plataforma está bloqueada'
        CompanyClient.create!(final_client: final_client, company: company)
        PaymentCompany.create!(company: company, payment_option: pay_boleto1)

        company.blocked!

        post '/api/v1/charges', params: { charge: { client_token: final_client.token,
                                                    company_token: company.token, product_token: product.token,
                                                    payment_method: pay_boleto1.name,
                                                    client_address: 'Rua 1, numero 2, Bairro X, Cidade 1, Estado Y',
                                                    due_deadline: '24/12/2023' } }

        expect(response).to have_http_status(403)
        expect(response.content_type).to include('application/json')
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['error']).to eq(message)
      end
    end
  end
end
