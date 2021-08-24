require 'rails_helper'

describe 'client register product' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:user_admin) { User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company) }
  let(:user) { User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company) }

  it 'successfully' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

    login_as user, scope: :user
    visit clients_company_path(company[:token])
    click_on 'Produtos cadastrados'
    click_on 'Registrar produto'
    fill_in 'Nome', with: 'Produto 1'
    fill_in 'Preço', with: '10'
    fill_in 'Desconto no Cartão de Crédito', with: 2
    expect { click_on 'Registrar' }.to change { Product.count }.by(1)

    expect(page).to have_content('Produto 1')
    expect(page).to have_content('Preço: R$ 10,00')
    expect(page).to have_content('Desconto no Cartão de Crédito: 2,00%')
    expect(HistoricProduct.count).to be(1)
  end
  it 'same product but diferent companies' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    company2 = Company.create(corporate_name: 'Empresa1 SA', cnpj: '44.212.343/0001-42', state: 'São Paulo',
                              city: 'Campinas', district: 'Csmpos', street: 'rua 2', number: '13',
                              address_complement: '', billing_email: 'faturamento@empresa1.com')
    product = Product.create!(name: 'Produto 2', price: 53, boleto_discount: 1, company: company2)

    login_as user, scope: :user
    visit clients_company_path(company[:token])
    click_on 'Produtos cadastrados'
    click_on 'Registrar produto'
    fill_in 'Nome', with: 'Produto 2'
    fill_in 'Preço', with: '53'
    fill_in 'Desconto no Cartão de Crédito', with: 3
    click_on 'Registrar produto'

    expect(page).to have_content('Produto 2')
    expect(page).to have_content('Preço: R$ 53,00')
    expect(page).to have_content('Desconto no Cartão de Crédito: 3,00%')
    expect(HistoricProduct.count).to be(2)
  end
  context 'failure' do
    it 'missing information' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

      login_as user, scope: :user
      visit clients_company_path(company[:token])
      click_on 'Produtos cadastrados'
      click_on 'Registrar produto'
      fill_in 'Nome', with: ''
      fill_in 'Preço', with: ''

      fill_in 'Desconto no Cartão de Crédito', with: ''

      click_on 'Registrar produto'

      expect(page).to have_content('não pode ficar em branco', count: 2)
      expect(HistoricProduct.count).to be(0)
    end
    it 'product already registered same company' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      product = Product.create!(name: 'Produto 2', price: 53, boleto_discount: 1, company: company)

      login_as user, scope: :user
      visit clients_company_path(company[:token])
      click_on 'Produtos cadastrados'
      click_on 'Registrar produto'
      fill_in 'Nome', with: 'Produto 2'
      fill_in 'Preço', with: '23'

      fill_in 'Desconto no Cartão de Crédito', with: ''

      click_on 'Registrar produto'

      expect(page).to have_content('Produto já cadastrado')
      expect(HistoricProduct.count).to be(1)
    end
    it 'discount must be a number' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

      login_as user, scope: :user
      visit clients_company_path(company[:token])
      click_on 'Produtos cadastrados'
      click_on 'Registrar produto'
      fill_in 'Nome', with: 'Produto 2'
      fill_in 'Preço', with: '23'
      fill_in 'Desconto no Boleto', with: ''
      fill_in 'Desconto no Cartão de Crédito', with: ''
      fill_in 'Desconto no PIX', with: ''
      click_on 'Registrar produto'

      expect(page).to have_content('não é um número', count: 3)
      expect(HistoricProduct.count).to be(0)
    end
    it 'discount cannot be negative' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

      login_as user, scope: :user
      visit clients_company_path(company[:token])
      click_on 'Produtos cadastrados'
      click_on 'Registrar produto'
      fill_in 'Nome', with: 'Produto 2'
      fill_in 'Preço', with: '23'
      fill_in 'Desconto no Boleto', with: -1
      fill_in 'Desconto no Cartão de Crédito', with: -1
      fill_in 'Desconto no PIX', with: -1
      click_on 'Registrar produto'

      expect(page).to have_content('deve ser maior ou igual a 0.0', count: 3)
      expect(HistoricProduct.count).to be(0)
    end
  end
end
