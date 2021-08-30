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
    it 'company profile' do
      company
      token = company.token

      visit "/client_admin/companies/#{token}"

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
    it 'edit company' do
      company
      token = '5pjB8SDb74LH6bBnawe2'
      company.token = token
      visit "/client_admin/companies/#{token}/edit"

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
    it 'new company' do
      visit '/client_admin/companies/new'

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
    it 'payment chosen' do
      company
      visit payments_chosen_client_admin_company_path(company.token)

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
    it 'emails' do
      company
      visit emails_client_admin_company_path(company.token)

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
  end
  context 'client' do
    it 'company profile' do
      user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      user
      token = company.token

      login_as user, scope: :user
      visit "/client_admin/companies/#{token}"

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'edit company' do
      user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      token = company.token

      login_as user, scope: :user
      visit "/client_admin/companies/#{token}/edit"

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'new company' do
      user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      login_as user, scope: :user
      visit '/client_admin/companies/new'

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'payment chosen' do
      user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      login_as user, scope: :user
      visit payments_chosen_client_admin_company_path(company.token)

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'emails' do
      user_admin
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      login_as user, scope: :user
      visit emails_client_admin_company_path(company.token)

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
  end
end
