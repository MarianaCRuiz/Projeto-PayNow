require 'rails_helper'

describe 'register Boleto' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:pay_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}

  it 'client_admin register boleto succesfully' do
    DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
    boleto_option = pay_1
    bank_code = bank

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento'
    click_on 'Adicionar: Boleto'
    select "#{bank.code} - #{bank.bank}", from: 'Código do banco'
    fill_in 'Agência', with: '3040'
    fill_in 'Número da conta', with: '111.222-3'
    click_on 'Registrar boleto'
  
    expect(page).to have_content('Opção adicionada com sucesso')
    expect(page).to have_content('001')
    expect(page).to have_content('3040')
    expect(page).to have_content('111.222-3')
  end
  it 'cannot be blank' do
    DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)

    boleto_option = pay_1
    bank_code = bank
    
    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento' #Boleto PIX CC
    click_on 'Adicionar: Boleto'
    select "#{bank.code} - #{bank.bank}", from: 'Código do banco'
    fill_in 'Agência', with: ''
    fill_in 'Número da conta', with: ''
    click_on 'Registrar boleto'
  
    expect(page).to have_content('não pode ficar em branco', count: 2)
  end
  context 'uniquenes account number' do
    it 'all scopes' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
      BoletoRegisterOption.create!(company: company, payment_option: pay_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
      
      login_as user_admin, scope: :user
      visit client_admin_company_path(company[:token])
      click_on 'Opções de pagamento'
      click_on 'Adicionar opção de pagamento' #Boleto PIX CC
      click_on 'Adicionar: Boleto'
      select "#{bank.code} - #{bank.bank}", from: 'Código do banco'
      fill_in 'Agência', with: '2050'
      fill_in 'Número da conta', with: '123.555-8'
      click_on 'Registrar boleto'

      expect(page).to have_content('já está em uso')    
    end
    it 'differeent bank' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
      BoletoRegisterOption.create!(company: company, payment_option: pay_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
      bank_2 = BankCode.create!(code: '029', bank:'Banco Itaú Consignado S.A.')

      login_as user_admin, scope: :user
      visit client_admin_company_path(company[:token])
      click_on 'Opções de pagamento'
      click_on 'Adicionar opção de pagamento' #Boleto PIX CC
      click_on 'Adicionar: Boleto'
      select "#{bank_2.code} - #{bank_2.bank}", from: 'Código do banco'
      fill_in 'Agência', with: '2050'
      fill_in 'Número da conta', with: '123.555-8'
      click_on 'Registrar boleto'

      expect(page).to have_content('Opção adicionada com sucesso')
      expect(page).to have_content('029')
      expect(page).to have_content('2050')
      expect(page).to have_content('123.555-8')   
    end
    it 'differeent agency_number' do
      DomainRecord.create!(email_client_admin: user_admin, domain: 'codeplay.com', company: company)
      BoletoRegisterOption.create!(company: company, payment_option: pay_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
      
      login_as user_admin, scope: :user
      visit client_admin_company_path(company[:token])
      click_on 'Opções de pagamento'
      click_on 'Adicionar opção de pagamento' #Boleto PIX CC
      click_on 'Adicionar: Boleto'
      select "#{bank.code} - #{bank.bank}", from: 'Código do banco'
      fill_in 'Agência', with: '3020'
      fill_in 'Número da conta', with: '123.555-8'
      click_on 'Registrar boleto'

      expect(page).to have_content('Opção adicionada com sucesso')
      expect(page).to have_content('001')
      expect(page).to have_content('3020')
      expect(page).to have_content('123.555-8')   
    end
  end
end