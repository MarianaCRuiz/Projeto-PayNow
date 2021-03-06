require 'rails_helper'

describe 'authentication' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:user_admin) { User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company) }
  let(:user) { User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company) }
  let(:pay_creditcard1) do
    PaymentOption.create!(name: 'Cartão de Crédito PISA', fee: 1.9, max_money_fee: 20, payment_type: 1)
  end
  let(:creditcard) do
    CreditCardRegisterOption.create!(company: company, payment_option: pay_creditcard1,
                                     credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
  end

  context 'client_admin controller' do
    context 'visitor' do
      it 'POST' do
        pay = pay_creditcard1
        post client_admin_payment_option_credit_card_register_options_path(pay), params: {
          credit_card_register_option: {
            company: company, payment_option: pay_creditcard1,
            credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm'
          }
        }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'PATCH update' do
        cc = creditcard
        pay = pay_creditcard1

        patch client_admin_payment_option_credit_card_register_option_path(pay, cc)

        expect(response).to redirect_to(new_user_session_path)
      end
      it 'PATCH exclude' do
        cc = creditcard
        pay = pay_creditcard1

        patch exclude_client_admin_payment_option_credit_card_register_option_path(pay, cc)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context 'client' do
      it 'POST' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        pay = pay_creditcard1

        login_as user, scope: :user
        post client_admin_payment_option_credit_card_register_options_path(pay), params:
                                                                { credit_card_register_option: {
                                                                  company: company, payment_option: pay_creditcard1,
                                                                  credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm'
                                                                } }

        expect(response).to redirect_to(root_path)
      end
      it 'PATCH update' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        cc = creditcard
        pay = pay_creditcard1

        login_as user, scope: :user
        patch client_admin_payment_option_credit_card_register_option_path(pay, cc)

        expect(response).to redirect_to(root_path)
      end
      it 'PATCH exclude' do
        DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
        cc = creditcard
        pay = pay_creditcard1

        login_as user, scope: :user
        patch exclude_client_admin_payment_option_credit_card_register_option_path(pay, cc)

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
