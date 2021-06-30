require 'rails_helper'

describe 'client_admin edit product' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role:1, company: company)}
  let(:product) {Product.create!(name:'Produto 1', price: 53, boleto_discount: 1, company: company)}
  it 'successfully' do
    user_admin1 = user_admin
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    product1 = product

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Produtos cadastrados'
    click_on 'Produto 1'
    click_on 'Atualizar dados'
    fill_in 'Nome', with: 'Produto 1 novo'
    fill_in 'Preço', with: '15'
    expect{ click_on 'Atualizar'}.to change{ Product.count }.by(0)

    expect(page).to have_content('Produto 1 novo')
    expect(page).to have_content('Preço: R$ 15')
    expect(HistoricProduct.count).to be(2)
  end
  it 'same product but diferent companies' do
    user_admin1 = user_admin
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    product1 = product
    company2 = Company.create(corporate_name: 'Empresa1 SA', cnpj: '44.212.343/0001-42' , state: 'São Paulo', 
                              city: 'Campinas', district: 'Csmpos', street: 'rua 2', number: '13', 
                              address_complement: '', billing_email: 'faturamento@empresa1.com')
    product2 = Product.create!(name:'Produto 2', price: 58, boleto_discount: 1, company: company2)

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Produtos cadastrados'
    click_on 'Produto 1'
    click_on 'Atualizar dados'
    fill_in 'Nome', with: 'Produto 2'
    fill_in 'Preço', with: '58'
    fill_in 'Desconto no Boleto', with: 1
    expect{ click_on 'Atualizar'}.to change{ Product.count }.by(0)

    expect(page).to have_content('Produto 2')
    expect(page).to have_content('Preço: R$ 58,00')
    expect(page).to have_content('Desconto no Boleto: 1,00%')  
    expect(HistoricProduct.count).to be(3)
  end 
  context 'failure' do
    it 'missing information' do
      user_admin1 = user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      product1 = product

      login_as user_admin, scope: :user
      visit client_admin_company_path(company[:token])
      click_on 'Produtos cadastrados'
      click_on 'Produto 1'
      click_on 'Atualizar dados'
      fill_in 'Nome', with: ''
      fill_in 'Preço', with: ''
      fill_in 'Desconto no Boleto', with: 1
      expect{ click_on 'Atualizar'}.to change{ Product.count }.by(0)

      expect(page).to have_content('não pode ficar em branco', count: 2)
      expect(HistoricProduct.count).to be(1)
    end
    it 'product already registered same company' do
      user_admin1 = user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      product1 = product
      product2 = Product.create!(name:'Produto 2', price: 23, boleto_discount: 6, company: company)
      
      login_as user_admin, scope: :user
      visit client_admin_company_path(company[:token])
      click_on 'Produtos cadastrados'
      click_on 'Produto 1'
      click_on 'Atualizar dados'
      fill_in 'Nome', with: 'Produto 2'
      fill_in 'Preço', with: '23'
      click_on 'Atualizar'

      expect(page).to have_content('Produto já cadastrado') 
      expect(HistoricProduct.count).to be(2) 
    end
    it 'discount must be a number' do
      user_admin1 = user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      product1 = product
      
      login_as user_admin, scope: :user
      visit client_admin_company_path(company[:token])
      click_on 'Produtos cadastrados'
      click_on 'Produto 1'
      click_on 'Atualizar dados'
      fill_in 'Nome', with: 'Produto 2'
      fill_in 'Preço', with: '23'
      fill_in 'Desconto no Boleto', with: ''
      fill_in 'Desconto no Cartão de Crédito', with: ''
      fill_in 'Desconto no PIX', with: ''
      click_on 'Atualizar'

      expect(page).to have_content('não é um número', count: 3)
      expect(HistoricProduct.count).to be(1) 
    end
    it 'discount cannot be negative' do
      user_admin1 = user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      product1 = product
      
      login_as user_admin, scope: :user
      visit client_admin_company_path(company[:token])
      click_on 'Produtos cadastrados'
      click_on 'Produto 1'
      click_on 'Atualizar dados'
      fill_in 'Nome', with: 'Produto 2'
      fill_in 'Preço', with: '23'
      fill_in 'Desconto no Boleto', with: -1
      fill_in 'Desconto no Cartão de Crédito', with: -1
      fill_in 'Desconto no PIX', with: -1
      click_on 'Atualizar'

      expect(page).to have_content('deve ser maior ou igual a 0.0', count: 3)
      expect(HistoricProduct.count).to be(1) 
    end
  end
end