require 'rails_helper'

describe 'client_admin deactivate product' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:user) {User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company)}
  let(:product) {Product.create!(name:'Produto 1', price: 53, boleto_discount: 1, company: company)}
  
  it 'successfully' do
    DomainRecord.create!(email_client_admin: user_admin.email, domain: 'codeplay.com', company: company)
    DomainRecord.create!(email: user.email, domain: 'codeplay.com', company: company)
    HistoricProduct.create(product: product, company: company, price: product.price)

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Produtos cadastrados'
    click_on 'Produto 1'
    click_on 'Excluir produto'

    expect(page).to have_content('Produto excluído com sucesso')
    expect(page).to_not have_content('Produto 1')
    expect(page).to_not have_content('Preço: R$ 52,00')
    expect(page).to_not have_content('Desconto no Boleto: 1,00%')  
  end
end