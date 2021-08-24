require 'rails_helper'

describe 'cannot access through url' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:user_admin) { User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company) }
  let(:user) { User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company) }
  context 'visitor' do
    it 'companies' do
      token = company.token

      visit '/admin/companies'

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
    it 'company profile' do
      token = company.token

      visit "/admin/companies/#{token}"

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
    it 'edit company' do
      token = company.token
      visit "/admin/companies/#{token}/edit"

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
    it 'emails' do
      visit emails_admin_company_path(company.token)

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
  end
  context 'client' do
    it 'companies' do
      user1 = user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      token = company.token

      login_as user, scope: :user
      visit '/admin/companies'

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'company profile' do
      user1 = user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      token = company.token

      login_as user, scope: :user
      visit "/admin/companies/#{token}"

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'edit company' do
      user1 = user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      token = company.token

      login_as user, scope: :user
      visit "/admin/companies/#{token}/edit"

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'emails' do
      user1 = user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

      login_as user, scope: :user
      visit emails_admin_company_path(company.token)

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
  end
  context 'client_admin' do
    it 'companies' do
      user1 = user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      token = company.token

      login_as user_admin, scope: :user
      visit '/admin/companies'

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'company profile' do
      user1 = user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      token = company.token

      login_as user_admin, scope: :user
      visit "/admin/companies/#{token}"

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'edit company' do
      user1 = user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      token = company.token

      login_as user_admin, scope: :user
      visit "/admin/companies/#{token}/edit"

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'emails' do
      user1 = user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

      login_as user_admin, scope: :user
      visit emails_admin_company_path(company.token)

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
  end
end
