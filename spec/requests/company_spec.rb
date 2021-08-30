require 'rails_helper'

describe 'authentication' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:user_admin) { User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company) }
  let(:user) { User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company) }

  context 'client_admin controller' do
    context 'visitor' do
      it 'POST' do
        post client_admin_companies_path, params: { company: { corporate_name: 'Codeplay SA',
                                                               cnpj: '11.222.333/0001-44', state: 'São Paulo',
                                                               city: 'Campinas', district: 'Inova', street: 'rua 1',
                                                               number: '12', address_complement: '',
                                                               billing_email: 'faturamento@codeplay.com' } }
        expect(response).to redirect_to(new_user_session_path)
      end
      it 'PATCH UPDATE' do
        company

        patch client_admin_company_path(company.token)

        expect(response).to redirect_to(new_user_session_path)
      end
      it 'PATCH new token' do
        company

        patch token_new_client_admin_company_path(company.token)

        expect(response).to redirect_to(new_user_session_path)
      end
      it 'block email' do
        company
        patch block_email_client_admin_company_path(company.token)
        expect(response).to redirect_to(new_user_session_path)
      end
      it 'unblock email' do
        company
        patch unblock_email_client_admin_company_path(company.token)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context 'client' do
      it 'POST' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

        login_as user, scope: :user
        post client_admin_companies_path, params: { company: { corporate_name: 'Codeplay SA',
                                                               cnpj: '11.222.333/0001-44',
                                                               state: 'São Paulo', city: 'Campinas',
                                                               district: 'Inova', street: 'rua 1',
                                                               number: '12', address_complement: '',
                                                               billing_email: 'faturamento@codeplay.com' } }

        expect(response).to redirect_to(root_path)
      end
      it 'PATCH UPDATE' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        company

        login_as user, scope: :user
        patch client_admin_company_path(company.token)

        expect(response).to redirect_to(root_path)
      end
      it 'PATCH new token' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        company

        login_as user, scope: :user
        patch token_new_client_admin_company_path(company.token)

        expect(response).to redirect_to(root_path)
      end
      it 'block email' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        company

        login_as user, scope: :user
        patch block_email_client_admin_company_path(company.token)

        expect(response).to redirect_to(root_path)
      end
      it 'unblock email' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        company

        login_as user, scope: :user
        patch unblock_email_client_admin_company_path(company.token)

        expect(response).to redirect_to(root_path)
      end
    end
  end
  context 'admin controller' do
    context 'visitor' do
      it 'PATCH UPDATE' do
        company

        patch admin_company_path(company.token)

        expect(response).to redirect_to(new_user_session_path)
      end
      it 'PATCH new token' do
        company

        patch token_new_admin_company_path(company.token)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context 'client_admin' do
      it 'PATCH UPDATE' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        company

        login_as user_admin, scope: :user
        patch admin_company_path(company.token)

        expect(response).to redirect_to(root_path)
      end
      it 'PATCH new token' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        company

        login_as user_admin, scope: :user
        patch token_new_admin_company_path(company.token)

        expect(response).to redirect_to(root_path)
      end
      it 'block email' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        company

        login_as user_admin, scope: :user
        patch block_email_admin_company_path(company.token)

        expect(response).to redirect_to(root_path)
      end
      it 'unblock email' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        company

        login_as user_admin, scope: :user
        patch unblock_email_admin_company_path(company.token)

        expect(response).to redirect_to(root_path)
      end
    end
    context 'client' do
      it 'PATCH UPDATE' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        company

        login_as user, scope: :user
        patch admin_company_path(company.token)

        expect(response).to redirect_to(root_path)
      end
      it 'PATCH new token' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        company

        login_as user, scope: :user
        patch token_new_admin_company_path(company.token)

        expect(response).to redirect_to(root_path)
      end
      it 'block email' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        company

        login_as user, scope: :user
        patch block_email_admin_company_path(company.token)

        expect(response).to redirect_to(root_path)
      end
      it 'unblock email' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        company

        login_as user, scope: :user
        patch unblock_email_admin_company_path(company.token)

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
