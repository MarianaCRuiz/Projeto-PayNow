require 'rails_helper'

describe CompanyClient do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:company_2) {Company.create!(corporate_name: 'Empresa SA', cnpj: '11.888.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@empresa.com')}
  let(:final_client) {FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599')}

  context 'validation' do
    it 'uniqueness scope company' do
      CompanyClient.create!(company: company, final_client: final_client)
      company_client = CompanyClient.new(company: company, final_client: final_client)
      company_client.valid?
      expect(company_client.errors[:final_client_id]).to include('já está em uso') 
    end
    it 'uniqueness different companies' do
      CompanyClient.create!(company: company_2, final_client: final_client)
      company_client = CompanyClient.new(company: company, final_client: final_client)
      company_client.valid?
      expect(company_client.errors.count).to eq(0) 
    end
  end
end
