require 'rails_helper'

describe 'final client api' do
  context 'POST final client api' do
    xit 'generating token to final client successfully' do
    end
    xit 'missing data' do
    end
    xit 'token must be uniq' do
    end
  end
  context 'GET api/v1/final_client' do
    it 'should get final client' do
      c_1 = FinalClient.create!(name: 'Final Client 1', cpf: '12312312366', token: SecureRandom.base58(20))
    

      get "/api/v1/final_clients/#{c_1.token}"
      expect(response).to have_http_status(200)
      expect(response.content_type).to include('application/json')
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['token']).to_not be_empty
      expect(parsed_body['name']).to eq('Final Client 1')
      expect(parsed_body['cpf']).to eq('12312312366')
    end
    xit 'returns no final client' do
    end
    xit 'should not find by token' do
    end
  end
end