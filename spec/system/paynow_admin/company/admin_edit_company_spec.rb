require 'rails_helper'

describe 'edit company' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo',
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                address_complement: '', billing_email: 'faturamento@codeplay.com')}

  it 'admin edit company profile' do
    Admin.create!(email:'user1@paynow.com.br')
    admin = User.create!(email:'user1@paynow.com.br', password: '123456', role: 2)
    company1 = company

    login_as admin, scope: :user
    visit root_path
    click_on 'Empresas cadastradas'
    click_on 'Codeplay SA'
    click_on 'Atualizar dados da empresa'
    fill_in 'Cidade', with: 'Cidade x'
    fill_in 'Bairro', with: 'Bairro x'
    fill_in 'Rua', with: 'Rua x'
    expect{ click_on 'Atualizar' }.to change{ Company.count }.by(0)

    expect(page).to have_content('Codeplay SA')
    expect(page).to have_content('11.222.333/0001-44')
    expect(page).to have_content('Endereço de faturamento')
    expect(page).to have_content('São Paulo')
    expect(page).to have_content('Cidade x')
    expect(page).to have_content('Bairro x')
    expect(page).to have_content('Rua x')
    expect(page).to have_content('12')
    expect(page).to have_content('Email de faturamento')
    expect(page).to have_content('faturamento@codeplay.com')
    expect(page).to have_link('Atualizar dados da empresa')
    expect(HistoricCompany.count).to eq(2)
  end
  it 'admin edit profile failure' do
    Admin.create!(email:'user1@paynow.com.br')
    admin = User.create!(email:'user1@paynow.com.br', password: '123456', role: 2)
    company1 = company

    login_as admin, scope: :user
    visit root_path
    click_on 'Empresas cadastradas'
    click_on 'Codeplay SA'
    click_on 'Atualizar dados da empresa'
    fill_in 'Cidade', with: 'Cidade x'
    fill_in 'Bairro', with: 'Bairro x'
    fill_in 'Rua', with: ''
    click_on 'Atualizar'

    expect(page).to have_content('não pode ficar em branco')
    expect(HistoricCompany.count).to eq(1)
  end
  it 'admin request new company token' do
    Admin.create!(email:'user1@paynow.com.br')
    admin = User.create!(email:'user1@paynow.com.br', password: '123456', role: 2)
    company1 = company
    token = company.token
    login_as admin, scope: :user
    visit root_path
    click_on 'Empresas cadastradas'
    click_on 'Codeplay SA'
    click_on 'Novo token'

    expect(page).to_not have_content(company.token)
    expect(HistoricCompany.count).to eq(2)
  end
end
