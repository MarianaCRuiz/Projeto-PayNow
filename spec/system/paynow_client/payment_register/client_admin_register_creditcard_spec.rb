require 'rails_helper'

describe 'register credit card option' do
  it 'client_admin register credit card succesfully' do
    company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , 
                              state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                              street: 'rua 1', number: '12', address_complement: '', 
                              billing_email: 'person1@codeplay.com',
                              token: SecureRandom.base58(20))
    payment_option = PaymentOption.create!(name: 'Cartão de Crédito MASTERCHEF', fee: 1.3, max_money_fee: 23, icon: fixture_file_upload('CreditCard.jpg', ('image/jpg')))
  
    user_client_admin = User.create!(email:'user1@codeplay.com', password: '123456', role: 'client_admin', company: company)
    token = SecureRandom.base58(20)

    login_as user_client_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on 'Adicionar opção de pagamento' #Boleto PIX CC
    click_on 'Adicionar Cartão de Crédito MASTERCHEF'
    fill_in 'Código operadora', with: token
    click_on 'Registrar cartão'
  
    expect(page).to have_content('Opção adicionada com sucesso')
    expect(page).to have_content(token)
    expect(page).to have_content('Cartão de Crédito MASTERCHEF')
  end
  xit 'cannot be blank' do
  end
  xit 'bank token uniq' do
  end
end