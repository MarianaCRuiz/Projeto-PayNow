require 'rails_helper'

describe FinalClient do
  context 'validation' do
    it 'cannot be blank' do
      company_client = FinalClient.new
      company_client.valid?
      expect(company_client.errors[:name]).to include('não pode ficar em branco') 
      expect(company_client.errors[:cpf]).to include('não pode ficar em branco') 
    end
    it 'uniqueness' do
      FinalClient.create!(name: 'Client', cpf: '11199922244')
      company_client = FinalClient.new(name: 'Client', cpf: '11199922244')
      company_client.valid?
      expect(company_client.errors[:cpf]).to include('já está em uso') 
    end
  end
end

