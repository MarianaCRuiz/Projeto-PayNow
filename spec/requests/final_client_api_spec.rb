require 'rails_helper'

describe 'final client api' do
  context 'POST final client api' do
    it 'generating final client token successfully' do
      token = 'kamd38Jn73hV29H785Vg'
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , 
                                state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                street: 'rua 1', number: '12', address_complement: '', 
                                billing_email: 'faturamento@codeplay.com', token: token)
      company.update(token: 'kamd38Jn73hV29H785Vg')

      post "/api/v1/tokens/#{company.token}/final_clients", params: {final_client: {name: 'Client final 1', cpf: '11122233344'}}

      expect(response).to have_http_status(201)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['token']).to_not be_empty
      expect(parsed_body['name']).to eq('Client final 1')
      expect(parsed_body['cpf']).to eq('11122233344')
    end
    it 'missing data' do
      token = 'kamd38Jn73ha9nH785Vg'
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , 
                                state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                street: 'rua 1', number: '12', address_complement: '', 
                                billing_email: 'faturamento@codeplay.com')
      company.update(token: token)

      post "/api/v1/tokens/#{company.token}/final_clients", params: {final_client: {name: '', cpf: ''}}

      expect(response).to have_http_status(400)
      expect(response.body).to be_empty
    end
    xit 'params must be uniq' do
    end
    xit 'token must be uniq' do
    end
    context 'authetication' do
      xit 'just admin' do
      end
    end
  end

  context 'GET api/v1/final_client' do  #provavelmente não será necessário
    it 'should get final client token' do
    end
    xit 'returns no final client' do
    end
    xit 'should not find by token' do
    end
  end
end