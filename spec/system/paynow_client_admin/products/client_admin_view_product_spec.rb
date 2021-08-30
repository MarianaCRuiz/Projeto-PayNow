require 'rails_helper'

describe 'client_admin register product' do
  let(:company) do
    Company.create!(corporate_name: 'Empresa 2 SA', cnpj: '11.222.333/0002-45', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@empresa2.com')
  end
  let(:user_admin) { User.create!(email: 'admin@empresa2.com', password: '123456', role: 1, company: company) }
  let(:user) { User.create!(email: 'user@empresa2.com', password: '123456', role: 0, company: company) }
  it 'index empty' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Produtos cadastrados'

    expect(page).to have_content('Nenhum produto cadastrado')
    expect(page).to have_link('Registrar produto')
  end
  it 'index' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    Product.create!(name: 'Produto 1', price: 10, boleto_discount: 2, company: company)
    Product.create!(name: 'Produto 2', price: 20, boleto_discount: 1, company: company)

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Produtos cadastrados'

    expect(page).to have_link('Produto 1')
    expect(page).to have_content('Preço: R$ 10,00')
    expect(page).to have_link('Produto 2')
    expect(page).to have_content('Preço: R$ 20,00')
    expect(page).to have_link('Registrar produto')
  end
  it 'show' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    product = Product.create!(name: 'Produto 1', price: 10, boleto_discount: 2, company: company)

    login_as user_admin, scope: :user
    visit client_admin_company_product_path(company[:token], product[:token])

    expect(page).to have_content('Produto 1')
    expect(page).to have_content('Preço: R$ 10,00')
    expect(page).to have_content('Desconto no Boleto: 2,00%')
  end
end
