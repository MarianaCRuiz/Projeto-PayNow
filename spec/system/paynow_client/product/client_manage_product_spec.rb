require 'rails_helper'

describe 'manage product' do
  context 'register' do
    it 'successfully' do
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
      expect{ click_on 'Registrar' }.to change{ Product.count }.by(1)

      expect(page).to have_content('Produto 1')
      expect(page).to have_content('Preço: R$ 16.0')
      expect(page).to have_content('Desconto Boleto(%): 0.4')
      expect(page).to have_content('Desconto Cartão de Crédito(%): 2.3')
      expect(page).to have_content('Desconto PIX(%): 4.1')
      expect(page).to have_link('Produtos')
    end
    xit 'product and price cannot be blank' do
    end
    xit 'price and discounts cannot be negative' do
    end
    xit 'already registered' do
    end
  end
  context 'update product data' do
    xit 'successfully' do
    end
    xit 'product and price cannot be blank' do
    end
    xit 'price and discounts cannot be negative' do
    end
  end
end