require 'rails_helper'

describe 'client_admin block client' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:user_admin) { User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company) }
  let(:user) { User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company) }

  it 'block client' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    user

    login_as user_admin, scope: :user
    visit root_path
    click_on 'Codeplay SA'
    click_on 'Emails cadastrados'
    click_on "Bloquear #{user.email}"

    expect(page).to have_content('Email bloqueado com sucesso')
    expect(page).to have_content('Bloqueado')
  end
  it 'unblock client' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    DomainRecord.find_by(email: user.email).blocked!

    login_as user_admin, scope: :user
    visit root_path
    click_on 'Codeplay SA'
    click_on 'Emails cadastrados'
    click_on "Desbloquear #{user.email}"

    expect(page).to have_content('Email desbloqueado com sucesso')
    expect(page).to have_content('Permitido')
  end
  it 'blocked client cannot login' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    DomainRecord.find_by(email: user.email).blocked!
    login_as user, scope: :user
    visit root_path

    expect(user.role).to eq('blocked')
  end
end
