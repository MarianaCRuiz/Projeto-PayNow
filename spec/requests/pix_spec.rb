require 'rails_helper'

describe 'authentication' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:user) {User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company)}    
  let(:pay_3) {PaymentOption.create!(name: 'PIX_1', fee: 1.9, max_money_fee: 20, payment_type: 2)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  let(:pix_option) {PixRegisterOption.create!(company: company, payment_option: pay_3, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)}
  
  context 'client_admin controller' do
    context 'visitor' do
      it 'POST' do
        pay = pay_3
        post client_admin_payment_option_pix_register_options_path(pay), params: {pix_register_option: {
                                                                        company: company, 
                                                                        payment_option: pay_3, 
                                                                        pix_key: 'AJ86gt4fLBtcF296rTuN', 
                                                                        bank_code: bank}}
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'PATCH update' do
        pix = pix_option
        pay = pay_3

        patch client_admin_payment_option_pix_register_option_path(pay, pix)
        expect(response).to redirect_to(new_user_session_path)
      end
      it 'PATCH exclude' do
        pix = pix_option
        pay = pay_3

        patch exclude_client_admin_payment_option_pix_register_option_path(pay, pix)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context 'client' do
      it 'POST' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        pay = pay_3

        login_as user, scope: :user
        post client_admin_payment_option_pix_register_options_path(pay), params: {pix_register_option: {
                                                                        company: company, 
                                                                        payment_option: pay_3, 
                                                                        pix_key: 'AJ86gt4fLBtcF296rTuN', 
                                                                        bank_code: bank}}
      
        expect(response).to redirect_to(root_path)
      end
      it 'PATCH update' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        pay = pay_3
        pix = pix_option

        login_as user, scope: :user
        patch client_admin_payment_option_pix_register_option_path(pay, pix)
              
        expect(response).to redirect_to(root_path)
      end
      it 'PATCH exclude' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        pay = pay_3
        pix = pix_option

        login_as user, scope: :user
        patch exclude_client_admin_payment_option_pix_register_option_path(pay, pix)
              
        expect(response).to redirect_to(root_path)
      end
    end
  end
end       