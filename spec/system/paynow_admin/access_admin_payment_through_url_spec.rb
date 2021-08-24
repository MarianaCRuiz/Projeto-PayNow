require 'rails_helper'


describe 'authentication' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo',
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:user) {User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company)}

  context 'payment option' do
    context 'visitor' do
      it 'index' do
        visit admin_payment_options_path

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
      it 'new' do
        visit new_admin_payment_option_path

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
      it 'edit' do
        visit edit_admin_payment_option_path(1)

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
    end
    context 'client' do
      it 'index' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

        login_as user, scope: :user
        visit admin_payment_options_path

        expect(current_path).to eq(root_path)
        expect(page).to have_content('Acesso não autorizado')
      end
      it 'new' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

        login_as user, scope: :user
        visit new_admin_payment_option_path

        expect(current_path).to eq(root_path)
        expect(page).to have_content('Acesso não autorizado')
      end
      it 'edit' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

        login_as user, scope: :user
        visit edit_admin_payment_option_path(1)

        expect(current_path).to eq(root_path)
        expect(page).to have_content('Acesso não autorizado')
      end
    end
    context 'client_admin' do
      it 'index' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        login_as user_admin, scope: :user
        visit admin_payment_options_path

        expect(current_path).to eq(root_path)
        expect(page).to have_content('Acesso não autorizado')
      end
      it 'new' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        login_as user_admin, scope: :user
        visit new_admin_payment_option_path

        expect(current_path).to eq(root_path)
        expect(page).to have_content('Acesso não autorizado')
      end
      it 'edit' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

        login_as user_admin, scope: :user
        visit edit_admin_payment_option_path(1)

        expect(current_path).to eq(root_path)
        expect(page).to have_content('Acesso não autorizado')
      end
    end
  end
end
