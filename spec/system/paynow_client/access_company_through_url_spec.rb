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

      visit "/clients/companies/#{token}"

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
    it 'payment chosen' do
      company
      visit payments_chosen_clients_company_path(company.token)

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
  end
  context 'client_admin' do
    it 'company profile' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      company
      token = company.token

      login_as user_admin, scope: :user
      visit "/clients/companies/#{token}"

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'payment chosen' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

      login_as user_admin, scope: :user
      visit payments_chosen_clients_company_path(company.token)

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
  end
end
