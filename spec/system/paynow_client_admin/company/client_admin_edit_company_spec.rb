require 'rails_helper'

describe 'edit company' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:user_admin) { User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company) }
  let(:user) { User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company) }

  it 'client_admin edit company profile' do
    user_admin
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

    login_as user_admin, scope: :user
    visit root_path

    click_on 'Codeplay SA'
    click_on 'Atualizar dados da empresa'
    fill_in 'Cidade', with: 'Cidade x'
    fill_in 'Bairro', with: 'Bairro x'
    fill_in 'Rua', with: 'Rua x'
    expect { click_on 'Atualizar' }.to change { Company.count }.by(0)

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
  it 'client_admin edit profile failure' do
    user_admin
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

    login_as user_admin, scope: :user
    visit root_path
    click_on 'Codeplay SA'
    click_on 'Atualizar dados da empresa'
    fill_in 'Cidade', with: 'Cidade x'
    fill_in 'Bairro', with: 'Bairro x'
    fill_in 'Rua', with: ''
    click_on 'Atualizar'

    expect(page).to have_content('não pode ficar em branco')
    expect(HistoricCompany.count).to eq(1)
  end
  it 'client_admin request new company token' do
    user_admin
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    login_as user_admin, scope: :user
    visit root_path
    click_on 'Codeplay SA'
    click_on 'Requerer novo token'

    expect(page).to_not have_content(company.token)
    expect(HistoricCompany.count).to eq(2)
  end
end
