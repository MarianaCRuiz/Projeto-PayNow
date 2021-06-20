require 'rails_helper'

describe 'admin block company' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:client_admin) {User.create!(email:'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:client) {User.create!(email:'user@codeplay.com', password: '123456', role: 0, company: company)}

  context 'blocking' do
    it 'successfuly' do
      Admin.create!(email: "admin@paynow.com.br")
      Admin.create!(email: "admin2@paynow.com.br")
      admin = User.create!(email:'admin@paynow.com.br', password: '123456', role: 2, company: company)
      admin2 = User.create!(email:'admin2@paynow.com.br', password: '123456', role: 2, company: company)
      DomainRecord.create!(email_client_admin: client_admin.email, domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: client.email, domain: 'codeplay.com', company: company)
      
      login_as admin, scope: :user
      visit root_path
      click_on 'Empresas cadastradas'
      click_on 'Codeplay SA'
      click_on 'Bloquear'
      click_on 'Sair'
      
      login_as admin2, scope: :user
      visit root_path
      click_on 'Empresas cadastradas'
      click_on 'Codeplay SA'
      click_on 'Bloquear'

      expect(DomainRecord.find_by(email_client_admin: client_admin.email).status).to eq("blocked")
      expect(DomainRecord.find_by(email: client.email).status).to eq("blocked")
      expect(Company.last.status).to eq("blocked")
    end
    it 'faillure, do not receive confirmation' do
      Admin.create!(email: "admin@paynow.com.br")
      Admin.create!(email: "admin2@paynow.com.br")
      admin = User.create!(email:'admin@paynow.com.br', password: '123456', role: 2, company: company)
      admin2 = User.create!(email:'admin2@paynow.com.br', password: '123456', role: 2, company: company)
      DomainRecord.create!(email_client_admin: client_admin.email, domain: 'codeplay.com', company: company)
      DomainRecord.create!(email: client.email, domain: 'codeplay.com', company: company)
      
      login_as admin, scope: :user
      visit root_path
      click_on 'Empresas cadastradas'
      click_on 'Codeplay SA'
      click_on 'Bloquear'
      click_on 'Sair'
      
      expect(DomainRecord.find_by(email_client_admin: client_admin.email).status).to_not eq("blocked")
      expect(DomainRecord.find_by(email: client.email).status).to_not eq("blocked")
      expect(Company.last.status).to_not eq("blocked")
    end
  end  
  context 'after blocking' do
    it 'client_admin cannot access account' do
      DomainRecord.create!(email_client_admin: client_admin.email, domain: 'codeplay.com', company: company, status: 1)
      DomainRecord.create!(email: client.email, domain: 'codeplay.com', company: company)
      
      login_as client_admin, scope: :user
      visit root_path

      expect(DomainRecord.find_by(email_client_admin: client_admin.email).status).to eq("blocked")
      expect(page).to have_content("Sua conta está bloqueada, entre em contato com o nosso atendimento")
    end
    it 'client cannot access account' do
      DomainRecord.create!(email_client_admin: client_admin.email, domain: 'codeplay.com', company: company, status: 1)
      DomainRecord.create!(email: client.email, domain: 'codeplay.com', company: company, status: 1)
      
      login_as client, scope: :user
      visit root_path

      expect(DomainRecord.find_by(email: client.email).status).to eq("blocked")
      expect(page).to have_content("Sua conta está bloqueada, entre em contato com o nosso atendimento")
    end
  end
end