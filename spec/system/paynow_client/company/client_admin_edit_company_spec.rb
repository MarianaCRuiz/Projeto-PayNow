require 'rails_helper'

describe 'edit company' do
  it 'client_admin edit company profile' do
    company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '123', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')
    user_client_admin = User.create!(email:'user1@codeplay.com', password: '123456', role: 1, company: company)
    DomainRecord.create!(email_client_admin: user_client_admin.email, domain: 'codeplay.com', company: company )
   
    login_as user_client_admin, scope: :user
    visit root_path
  
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
    expect(page).to have_content('123')
    expect(page).to have_content('Email de faturamento')
    expect(page).to have_content('faturamento@codeplay.com')
    expect(page).to have_link('Atualizar dados da empresa')
  end
  it 'client_admin edit profile failure' do
    company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '123', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')
    user_client_admin = User.create!(email:'user1@codeplay.com', password: '123456', role: 1, company: company)
    DomainRecord.create!(email_client_admin: user_client_admin.email, domain: 'codeplay.com', company: company)

    login_as user_client_admin, scope: :user
    visit root_path
    click_on 'Codeplay SA'
    click_on 'Atualizar dados da empresa'
    fill_in 'Cidade', with: 'Cidade x'
    fill_in 'Bairro', with: 'Bairro x'
    fill_in 'Rua', with: ''
    click_on 'Atualizar'

    expect(page).to have_content('não pode ficar em branco')
  end
end