require 'rails_helper'  

describe 'client consult charges' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo',
                            city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                            address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:user) {User.create!(email: 'user@codeplay.com', password: '123456', role: 0, company: company)}
  let(:pay_boleto_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  let(:boleto) {BoletoRegisterOption.create!(company: company, payment_option: pay_boleto_1,
                                            bank_code: bank, agency_number: '2050',
                                            account_number: '123.555-8')}
  let(:product) {Product.create!(name:'Produto 1', price: 50, boleto_discount: 10, company: company)}
  let(:product_2) {Product.create!(name:'Produto 2', price: 60, boleto_discount: 10, company: company)}
  let(:final_client) {FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599')}
  let(:status_charge) {StatusCharge.create!(code: '01', description: 'Pendente de cobrança')}
  let(:charge) {Charge.create!(client_token: final_client.token,
                                client_name: 'Cliente 1', client_cpf: '11133355588',
                                company_token:company.token, product_token: product.token,
                                payment_method: pay_boleto_1.name, client_address: 'algum endereço',
                                due_deadline: '24/12/2023', company: company, final_client: final_client,
                                status_charge: status_charge, product: product,
                                payment_option: pay_boleto_1, price: 50, charge_price: 45 )}

  context 'visitor' do
    it 'index' do
      company1 = company

      visit clients_charges_path

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
    it 'all charges' do
      company1 = company
      token = '5pjB8SDb74LH6bBnawe2'
      company.token = token

      visit all_charges_clients_charges_path

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
    it 'time interval' do
      company1 = company
      token = '5pjB8SDb74LH6bBnawe2'
      company.token = token

      visit time_interval_clients_charges_path(days: 90)

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Para continuar, efetue login ou registre-se')
    end
  end
  context 'client_admin' do
    it 'index' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
      token = '5pjB8SDb74LH6bBnawe2'
      company.token = token

      login_as user_admin, scope: :user
      visit clients_charges_path

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'all charges' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

      login_as user_admin, scope: :user
      visit all_charges_clients_charges_path

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
    it 'time interval' do
      DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)

      login_as user_admin, scope: :user
      visit time_interval_clients_charges_path(days: 90)

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Acesso não autorizado')
    end
  end
end
