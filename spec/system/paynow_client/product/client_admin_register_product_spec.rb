require 'rails_helper'

describe 'client_admin register product' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:user) {User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company)}
  xit 'successfully' do
    DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
    DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Produtos Cadastrados'
    click_on 'Registrar produto'
    fill_in 'Nome', with: 'Produto 1'
    fill_in 'Preço', with: '10'
    fill_in 'Desconto no Boleto', with: ''
    fill_in 'Desconto no Cartão de Crédito', with: '2'
    fill_in 'Desconto no PIX', with: ''
    click_on 'Registrar produto'

    expect(page).to have_content('Produto 1')
    expect(page).to have_content('10')
    expect(page).to have_content('2')    
  end
end