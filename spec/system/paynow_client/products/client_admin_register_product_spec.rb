require 'rails_helper'

describe 'client_admin register product' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}

  it 'successfully' do
    DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Produtos cadastrados'
    click_on 'Registrar produto'
    fill_in 'Nome', with: 'Produto 1'
    fill_in 'Preço', with: '10'
    fill_in 'Desconto no Boleto', with: ''
    fill_in 'Desconto no Cartão de Crédito', with: '2'
    fill_in 'Desconto no PIX', with: ''
    expect{ click_on 'Registrar'}.to change{ Product.count }.by(1)

    expect(page).to have_content('Produto 1')
    expect(page).to have_content('Preço: R$ 10')
    expect(page).to have_content('Desconto no Cartão de Crédito(%): 2')
    expect(HistoricProduct.count).to be(1)
  end
  it 'same product but diferent companies' do
    DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
    company2 = Company.create(corporate_name: 'Empresa1 SA', cnpj: '44.212.343/0001-42' , state: 'São Paulo', 
                              city: 'Campinas', district: 'Csmpos', street: 'rua 2', number: '13', 
                              address_complement: '', billing_email: 'faturamento@empresa1.com')
    product = Product.create!(name:'Produto 2', price: 53, boleto_discount: 1, company: company2)
    HistoricProduct.create(product: product, company: company2, price: product.price)

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Produtos cadastrados'
    click_on 'Registrar produto'
    fill_in 'Nome', with: 'Produto 2'
    fill_in 'Preço', with: '53'
    fill_in 'Desconto no Boleto', with: ''
    fill_in 'Desconto no Cartão de Crédito', with: '4'
    fill_in 'Desconto no PIX', with: ''
    click_on 'Registrar produto'

    expect(page).to have_content('Produto 2')
    expect(page).to have_content('Preço: R$ 53')
    expect(page).to have_content('Desconto no Cartão de Crédito(%): 4')  
    expect(HistoricProduct.count).to be(2)
  end 
  context 'failure' do
    it 'missing information' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)

      login_as user_admin, scope: :user
      visit client_admin_company_path(company[:token])
      click_on 'Produtos cadastrados'
      click_on 'Registrar produto'
      fill_in 'Nome', with: ''
      fill_in 'Preço', with: ''
      fill_in 'Desconto no Boleto', with: ''
      fill_in 'Desconto no Cartão de Crédito', with: ''
      fill_in 'Desconto no PIX', with: ''
      click_on 'Registrar produto'

      expect(page).to have_content('não pode ficar em branco', count: 2) 
      expect(HistoricProduct.count).to be(0)
    end
    it 'product already registered same company' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
    
      product = Product.create!(name:'Produto 2', price: 53, boleto_discount: 1, company: company)
      HistoricProduct.create(product: product, company: company, price: product.price)
      
      login_as user_admin, scope: :user
      visit client_admin_company_path(company[:token])
      click_on 'Produtos cadastrados'
      click_on 'Registrar produto'
      fill_in 'Nome', with: 'Produto 2'
      fill_in 'Preço', with: '23'
      fill_in 'Desconto no Boleto', with: ''
      fill_in 'Desconto no Cartão de Crédito', with: ''
      fill_in 'Desconto no PIX', with: ''
      click_on 'Registrar produto'

      expect(page).to have_content('Produto já cadastrado') 
      expect(HistoricProduct.count).to be(1) 
    end
  end
end