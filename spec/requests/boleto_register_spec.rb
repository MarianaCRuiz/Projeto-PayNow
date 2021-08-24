require 'rails_helper'

describe 'authentication' do
  let(:company) { Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo',
                                  city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                                  address_complement: '', billing_email: 'faturamento@codeplay.com') }
  let(:user_admin) { User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company) }
  let(:user) { User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company) }
  let(:pay_boleto_1) { PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0) }
  let(:bank) { BankCode.create!(code: '001', bank:'Banco do Brasil S.A.') }

  context 'client_admin controller' do
    context 'visitor' do
      it 'POST' do
        pay = pay_boleto_1
        post client_admin_payment_option_boleto_register_options_path(pay), params: { boleto_register_option: {
                                                                                      company: company,
                                                                                      payment_option: pay_boleto_1,
                                                                                      bank_code: bank,
                                                                                      agency_number: '2050',
                                                                                      account_number: '123.555-8' } }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'PATCH update' do
        boleto = BoletoRegisterOption.create!(company: company, payment_option: pay_boleto_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
        pay = pay_boleto_1
        patch client_admin_payment_option_boleto_register_option_path(pay, boleto)
        expect(response).to redirect_to(new_user_session_path)
      end
      it 'PATCH exclude' do
        boleto = BoletoRegisterOption.create!(company: company, payment_option: pay_boleto_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
        pay = pay_boleto_1
        patch exclude_client_admin_payment_option_boleto_register_option_path(pay, boleto)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context 'client' do
      it 'POST' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        pay = pay_boleto_1

        login_as user, scope: :user
        post client_admin_payment_option_boleto_register_options_path(pay), params: { boleto_register_option: {
                                                                                     company: company,
                                                                                     payment_option: pay_boleto_1,
                                                                                     bank_code: bank,
                                                                                     agency_number: '2050',
                                                                                     account_number: '123.555-8'} }

        expect(response).to redirect_to(root_path)
      end
      it 'PATCH update' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        boleto = BoletoRegisterOption.create!(company: company, payment_option: pay_boleto_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
        pay = pay_boleto_1

        login_as user, scope: :user
        patch client_admin_payment_option_boleto_register_option_path(pay, boleto)

        expect(response).to redirect_to(root_path)
      end
      it 'PATCH exclude' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        boleto = BoletoRegisterOption.create!(company: company, payment_option: pay_boleto_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
        pay = pay_boleto_1

        login_as user, scope: :user
        patch exclude_client_admin_payment_option_boleto_register_option_path(pay, boleto)

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
