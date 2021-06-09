require 'rails_helper'

describe 'product historic' do
  it 'product created generate historic' do
    company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
      city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
      address_complement: '', billing_email: 'person1@codeplay.com')
    DomainRecord.create!(email_client_admin: 'user1@codeplay.com', domain: 'codeplay.com', company_id: company.id)
    client_admin = User.create!(email:'user1@codeplay.com', password: '123456', role: 'client_admin', company: company)

    login_as client_admin, scope: :user
    visit client_admin_company_path(company.token)
    click_on 'Produtos'
    click_on 'Registrar produto'
    fill_in 'Nome', with: 'Produto 1'
    fill_in 'Preço', with: 16
    fill_in 'Desconto Boleto', with: 0.4
    fill_in 'Desconto Cartão de Crédito', with: 2.3
    fill_in 'Desconto PIX', with: 4.1
    expect{ click_on 'Registrar' }.to change{ HistoricProduct.count }.by(1)
  end
  xit 'product updated generate historic' do
  end
end