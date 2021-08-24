require 'rails_helper'

describe 'charge_status charges changing status api' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:product) do
    Product.create!(name: 'Produto 1', price: 50, boleto_discount: 10, credit_card_discount: 8, company: company)
  end
  let(:pay_boleto1) { PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0) }
  let(:bank) { BankCode.create!(code: '001', bank: 'Banco do Brasil S.A.') }
  let(:boleto) do
    BoletoRegisterOption.create!(company: company, payment_option: pay_boleto1, bank_code: bank, agency_number: '2050',
                                 account_number: '123.555-8')
  end
  let(:final_client) { FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599') }
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

  context 'change status' do
    it 'successfully 05' do
      CompanyClient.create!(final_client: final_client, company: company)
      product
      PaymentCompany.create!(company: company, payment_option: pay_boleto1)
      bank
      boleto
      charge1

      patch '/api/v1/change_status', params: { charge_status: { status_charge_code: '05',
                                                                charge_id: charge1.token, payment_date: '16/06/2021',
                                                                authorization_token: 'kjdnfv83276BSHDB' },
                                               company_token: company.token }

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['client_name']).to eq('Cliente final 1')
      expect(parsed_body['client_cpf']).to eq('11122255599')
      expect(parsed_body['client_address']).to eq('algum endereço')
      expect(parsed_body['payment_method']).to eq('Boleto')
      expect(parsed_body['status_returned']).to eq("Cobrança efetivada com sucesso\n")
    end
    it 'successfully 11' do
      CompanyClient.create!(final_client: final_client, company: company)
      product
      PaymentCompany.create!(company: company, payment_option: pay_boleto1)
      bank
      boleto
      charge1

      patch '/api/v1/change_status', params: { charge_status: { status_charge_code: '11',
                                                                charge_id: charge1.token, attempt_date: '16/06/2021',
                                                                authorization_token: 'kjdnfv83276BSHDB' },
                                               company_token: company.token }

      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['client_name']).to eq('Cliente final 1')
      expect(parsed_body['client_cpf']).to eq('11122255599')
      expect(parsed_body['client_address']).to eq('algum endereço')
      expect(parsed_body['payment_method']).to eq('Boleto')
      expect(parsed_body['status_returned']).to eq("Cobrança recusada sem motivo especificado\n")
    end
  end

  context 'failure' do
    it 'status invalid' do
      CompanyClient.create!(final_client: final_client, company: company)
      product
      PaymentCompany.create!(company: company, payment_option: pay_boleto1)
      bank
      boleto
      charge1

      patch '/api/v1/change_status',
            params: { charge_status: { status_charge_code: 10, charge_id: charge1.token },
                      company_token: company.token }

      expect(response).to have_http_status(412)
    end

    it 'missing payment date' do
      CompanyClient.create!(final_client: final_client, company: company)
      product
      PaymentCompany.create!(company: company, payment_option: pay_boleto1)
      status2 = StatusCharge.create!(code: '05', description: "Cobrança efetivada com sucesso\n")
      bank
      boleto
      charge1

      patch '/api/v1/change_status',
            params: { charge_status: { status_charge_code: status2.code, charge_id: charge1.token },
                      company_token: company.token }

      expect(response).to have_http_status(412)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['payment_date']).to eq(['não pode ficar em branco'])
    end

    it 'missing authorization token' do
      CompanyClient.create!(final_client: final_client, company: company)
      product
      PaymentCompany.create!(company: company, payment_option: pay_boleto1)
      status2 = StatusCharge.create!(code: '05', description: "Cobrança efetivada com sucesso\n")
      bank
      boleto
      charge1

      patch '/api/v1/change_status',
            params: { charge_status: { status_charge_code: status2.code, payment_date: '16/06/2021', charge_id: charge1.token },
                      company_token: company.token }

      expect(response).to have_http_status(412)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['authorization_token']).to eq(['não pode ficar em branco'])
    end

    it 'missing attempt date' do
      CompanyClient.create!(final_client: final_client, company: company)
      product
      PaymentCompany.create!(company: company, payment_option: pay_boleto1)
      bank
      boleto
      charge1

      patch '/api/v1/change_status',
            params: { charge_status: { status_charge_code: '11', charge_id: charge1.token },
                      company_token: company.token }

      expect(response).to have_http_status(412)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['attempt_date']).to eq(['não pode ficar em branco'])
    end

    it 'missing charge_id' do
      CompanyClient.create!(final_client: final_client, company: company)
      product
      PaymentCompany.create!(company: company, payment_option: pay_boleto1)
      bank
      boleto
      charge1

      patch '/api/v1/change_status',
            params: { charge_status: { status_charge_code: '11' }, company_token: company.token }

      expect(response).to have_http_status(404)
    end

    it 'missing status_charge_code' do
      CompanyClient.create!(final_client: final_client, company: company)
      product
      PaymentCompany.create!(company: company, payment_option: pay_boleto1)
      bank
      boleto
      charge1

      patch '/api/v1/change_status',
            params: { charge_status: { charge_id: charge1.token }, company_token: company.token }

      expect(response).to have_http_status(404)
    end
    it 'missing params' do
      CompanyClient.create!(final_client: final_client, company: company)
      product
      PaymentCompany.create!(company: company, payment_option: pay_boleto1)
      bank
      boleto
      charge1

      patch '/api/v1/change_status', params: {}

      expect(response).to have_http_status(412)
    end
  end
end
