require 'rails_helper'

describe 'client_admin deactivate product' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:user_admin) { User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company) }
  let(:user) { User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company) }
  let(:product) { Product.create!(name: 'Produto 1', price: 53, boleto_discount: 1, company: company) }

  it 'successfully' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    product

    login_as user, scope: :user
    visit clients_company_path(company[:token])
    click_on 'Produtos cadastrados'
    click_on 'Produto 1'
    click_on 'Excluir produto'

    expect(page).to have_content('Produto excluído com sucesso')
    expect(page).to_not have_content('Produto 1')
    expect(page).to_not have_content('Preço: R$ 52,00')
    expect(page).to_not have_content('Desconto no Boleto: 1,00%')
  end
end
