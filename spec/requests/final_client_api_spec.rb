require 'rails_helper'

describe 'final client api' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  context 'POST final client api' do
    it 'generating final client token successfully' do
      company1 = company

      post '/api/v1/final_clients',
           params: { final_client: { name: 'Client final 1', cpf: '11122233344' }, company_token: company.token }

      expect(response).to have_http_status(201)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['token']).to_not be_empty
      expect(parsed_body['name']).to eq('Client final 1')
      expect(parsed_body['cpf']).to eq('11122233344')
    end
    it 'missing data' do
      company1 = company

      post '/api/v1/final_clients', params: { final_client: {}, company_token: company.token }

      expect(response).to have_http_status(412)
      parsed_body = JSON.parse(response.body)
      expect(response.content_type).to include('application/json')
      expect(parsed_body['errors']).to eq('parâmetros inválidos')
    end
    it 'params must be uniq' do
      company1 = company
      final_client = FinalClient.create!(name: 'Teste 1', cpf: '11122233344')
      CompanyClient.create!(final_client: final_client, company: company)

      post '/api/v1/final_clients',
           params: { final_client: { name: 'Teste 1', cpf: '11122233344' }, company_token: company.token }

      expect(response).to have_http_status(409)
      parsed_body = JSON.parse(response.body)
      expect(response.content_type).to include('application/json')
      expect(parsed_body['cpf']).to eq(['já está em uso'])
    end
    it 'final client register from another company' do
      company1 = company
      final_client = FinalClient.create!(name: 'Teste 1', cpf: '11122233344')
      CompanyClient.create!(final_client: final_client, company: company)
      company2 = Company.create!(corporate_name: 'Empresa 1 SA', cnpj: '11.444.555/0001-44', state: 'São Paulo',
                                 city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                                 address_complement: '', billing_email: 'faturamento@empresa1.com')
      token = final_client.token
      post '/api/v1/final_clients',
           params: { final_client: { name: 'Teste 1', cpf: '11122233344' }, company_token: company2.token }

      expect(response).to have_http_status(202)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['token']).to eq(token.to_s)
      expect(parsed_body['name']).to eq('Teste 1')
      expect(parsed_body['cpf']).to eq('11122233344')
    end
  end
end
