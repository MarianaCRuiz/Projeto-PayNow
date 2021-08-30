require 'rails_helper'

describe 'register PIX option' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:user_admin) { User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company) }
  let(:pay_pix1) { PaymentOption.create!(name: 'pix1', fee: 1.9, max_money_fee: 20, payment_type: 2) }

  it 'client_admin register pix succesfully' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    bank = BankCode.create!(code: '001', bank: 'Banco do Brasil S.A.')
    token = SecureRandom.base58(20)
    pay_pix1

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento'
    click_on 'Adicionar: pix1'
    fill_in 'Chave PIX', with: token
    select "#{bank.code} - #{bank.bank}", from: 'Código do banco'
    click_on 'Registrar PIX'

    expect(page).to have_content('Opção adicionada com sucesso')
    expect(page).to have_content(token)
    expect(page).to have_content('pix1')
  end
  it 'cannot be blank' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    bank = BankCode.create!(code: '001', bank: 'Banco do Brasil S.A.')
    pay_pix1

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento'
    click_on 'Adicionar: pix1'
    fill_in 'Chave PIX', with: ''
    select "#{bank.code} - #{bank.bank}", from: 'Código do banco'
    click_on 'Registrar PIX'

    expect(page).to have_content('não pode ficar em branco')
  end
  it 'PIX key uniq' do
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    bank = BankCode.create!(code: '001', bank: 'Banco do Brasil S.A.')
    token = 'abc123ABC456DEF98nm2'
    pay_novo = PaymentOption.create!(name: 'PIX_2', fee: 1.9, max_money_fee: 20)
    PixRegisterOption.create!(payment_option: pay_novo, pix_key: token, bank_code: bank, company: company)
    pay_pix1

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento'
    click_on 'Adicionar: pix1'
    fill_in 'Chave PIX', with: token
    select "#{bank.code} - #{bank.bank}", from: 'Código do banco'
    click_on 'Registrar PIX'

    expect(page).to have_content('já está em uso')
  end
end
