require 'rails_helper'


describe 'needs authentication' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:user) {User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company)}
  let(:pay_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20)}
  let(:pay_2) {PaymentOption.create!(name: 'Cartão de Crédito MasterChef', fee: 1.2, max_money_fee: 24)}
  let(:pay_3) {PaymentOption.create!(name: 'PIX', fee: 1.3, max_money_fee: 21)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  
  context 'boleto' do
    context 'client' do
      it 'new' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        BoletoRegisterOption.create!(company: company, payment_option: pay_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
        PaymentCompany.create!(company: company, payment_option: pay_1)
        
        login_as user, scope: :user
        visit new_client_admin_payment_option_boleto_register_option_path(pay_1)
        
        expect(current_path).to eq(root_path)
        expect(page).to have_content('Acesso não autorizado')
      end
      xit 'edit' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        BoletoRegisterOption.create!(company: company, payment_option: pay_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
        PaymentCompany.create!(company: company, payment_option: pay_1)
      end
    end
    context 'visitor' do
      it 'new' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        BoletoRegisterOption.create!(company: company, payment_option: pay_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
        PaymentCompany.create!(company: company, payment_option: pay_1)
    
        visit new_client_admin_payment_option_boleto_register_option_path(pay_1)

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
        end
      xit 'edit' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        BoletoRegisterOption.create!(company: company, payment_option: pay_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
        PaymentCompany.create!(company: company, payment_option: pay_1)
      end
    end
  end
  context 'credit card' do
    context 'client' do
      it 'new' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        CreditCardRegisterOption.new(company: company, payment_option: pay_2, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
        PaymentCompany.create!(company: company, payment_option: pay_2)    

        login_as user, scope: :user
        visit new_client_admin_payment_option_credit_card_register_option_path(pay_2)
        
        expect(current_path).to eq(root_path)
        expect(page).to have_content('Acesso não autorizado')
      end
      xit 'edit' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        CreditCardRegisterOption.new(company: company, payment_option: pay_2, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
        PaymentCompany.create!(company: company, payment_option: pay_2)    
      end
    end
    context 'visitor' do
      it 'new' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        CreditCardRegisterOption.new(company: company, payment_option: pay_2, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
        PaymentCompany.create!(company: company, payment_option: pay_2)   

        visit new_client_admin_payment_option_credit_card_register_option_path(pay_2)

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
      xit 'edit' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        CreditCardRegisterOption.new(company: company, payment_option: pay_2, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
        PaymentCompany.create!(company: company, payment_option: pay_2)    
      end
    end
  end
  context 'pix' do
    context 'client' do
      it 'new' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        PixRegisterOption.create!(company: company, payment_option: pay_3, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)
        PaymentCompany.create!(company: company, payment_option: pay_3)
        
        login_as user, scope: :user
        visit new_client_admin_payment_option_pix_register_option_path(pay_3)
        
        expect(current_path).to eq(root_path)
        expect(page).to have_content('Acesso não autorizado')
      end
      xit 'edit' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        PixRegisterOption.create!(company: company, payment_option: pay_3, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)
        PaymentCompany.create!(company: company, payment_option: pay_3)
      end
    end
    context 'visitor' do
      it 'new' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        PixRegisterOption.create!(company: company, payment_option: pay_3, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)
        PaymentCompany.create!(company: company, payment_option: pay_3)
        
        visit new_client_admin_payment_option_pix_register_option_path(pay_3)

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('Para continuar, efetue login ou registre-se')
      end
      xit 'edit' do
        DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
        DomainRecord.create!(email: user, domain: 'codeplay.com', company: company)
        PixRegisterOption.create!(company: company, payment_option: pay_3, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)
        PaymentCompany.create!(company: company, payment_option: pay_3)
      end
    end
  end
end