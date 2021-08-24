require 'rails_helper'

describe 'accessing recipes' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:user_admin) { User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company) }
  let(:pay_boleto1) { PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0) }
  let(:pay_creditcard1) do
    PaymentOption.create(name: 'Cartão de Crédito MasterChef', fee: 1.2, max_money_fee: 24, payment_type: 1)
  end
  let(:pay_pix1) { PaymentOption.create(name: 'PIX', fee: 1.3, max_money_fee: 21, payment_type: 2) }
  let(:bank) { BankCode.create!(code: '001', bank: 'Banco do Brasil S.A.') }
  let(:boleto) do
    BoletoRegisterOption.create!(company: company, payment_option: pay_boleto1, bank_code: bank, agency_number: '2050',
                                 account_number: '123.555-8')
  end
  let(:credit_card) do
    CreditCardRegisterOption.create!(company: company, payment_option: pay_creditcard1,
                                     credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
  end
  let(:pix) do
    PixRegisterOption.create!(company: company, payment_option: pay_pix1, pix_key: 'AJ86gt4fLBtcF296rTuN',
                              bank_code: bank)
  end
  let(:product) { Product.create!(name: 'Produto 1', price: 50, boleto_discount: 10, company: company) }
  let(:product2) do
    Product.create!(name: 'Produto 2', price: 60, boleto_discount: 10, credit_card_discount: 15, company: company)
  end
  let(:product_3) do
    Product.create!(name: 'Produto 3', price: 70, boleto_discount: 10, pix_discount: 10, company: company)
  end
  let(:final_client) { FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599') }
  let(:final_client2) { FinalClient.create!(name: 'Cliente final 2', cpf: '11144455599') }
  let(:final_client_3) { FinalClient.create!(name: 'Cliente final 3', cpf: '11188855599') }
  let(:status_charge) { StatusCharge.create!(code: '05', description: "Cobrança efetivada com sucesso\n") }
  let(:charge1) do
    Charge.create!(client_name: final_client.name, client_cpf: final_client.cpf,
                   client_token: final_client.token, company_token: company.token,
                   product_token: product.token, payment_method: pay_boleto1.name,
                   client_address: 'algum endereço', due_deadline: '24/07/2021',
                   company: company, final_client: final_client,
                   status_charge: status_charge, product: product,
                   payment_option: pay_boleto1, price: 50, discount: 5,
                   charge_price: 45, payment_date: '17/06/2021')
  end
  let(:charge11) do
    Charge.create!(client_token: final_client2.token,
                   client_name: final_client2.name, client_cpf: final_client2.cpf,
                   company_token: company.token, product_token: product2.token,
                   payment_method: pay_creditcard1.name, card_number: '1111 2222 3333 4444',
                   card_name: 'CLIENTE X2', cvv_code: '123',
                   due_deadline: '15/06/2021', company: company, final_client: final_client2,
                   status_charge: status_charge, product: product2,
                   payment_option: pay_creditcard1, price: product2.price, discount: 9,
                   charge_price: 51, payment_date: '15/06/2021')
  end
  let(:charge12) do
    Charge.create!(client_token: final_client_3.token,
                   client_name: final_client_3.name, client_cpf: final_client_3.cpf,
                   company_token: company.token, product_token: product_3.token,
                   payment_method: pay_pix1.name, due_deadline: '14/06/2021',
                   company: company, final_client: final_client_3,
                   status_charge: status_charge, product: product_3,
                   payment_option: pay_pix1, price: product_3.price, discount: 7,
                   charge_price: 63, payment_date: '14/06/2021')
  end

  it 'successfully' do
    PaymentCompany.create!(company: company, payment_option: pay_boleto1)
    PaymentCompany.create!(company: company, payment_option: pay_creditcard1)
    PaymentCompany.create!(company: company, payment_option: pay_pix1)
    HistoricProduct.create(product: product, company: company, price: product.price)
    HistoricProduct.create(product: product2, company: company, price: product2.price)
    HistoricProduct.create(product: product_3, company: company, price: product_3.price)
    CompanyClient.create!(company: company, final_client: final_client)
    CompanyClient.create!(company: company, final_client: final_client2)
    CompanyClient.create!(company: company, final_client: final_client_3)
    Receipt.create!(due_deadline: charge1.due_deadline, payment_date: charge1.payment_date, charge: charge1,
                    authorization_token: 'nn9e32jnvaç')
    Receipt.create!(due_deadline: charge11.due_deadline, payment_date: charge11.payment_date, charge: charge11,
                    authorization_token: 'iyvca8e9ery8w7e')
    Receipt.create!(due_deadline: charge12.due_deadline, payment_date: charge12.payment_date, charge: charge12,
                    authorization_token: '0ufbwehfnweapi')
    boleto1 = boleto
    cc = credit_card
    pix1 = pix

    visit root_path
    click_on 'Recibos'
    fill_in 'Token de autorização',	with: 'nn9e32jnvaç'
    click_on 'Procurar'

    expect(page).to have_content('Cliente final 1')
    expect(page).to have_content('Produto 1')
    expect(page).to have_content('R$ 50,00')
    expect(page).to have_content('R$ 5,00')
    expect(page).to have_content('R$ 45,00')
    expect(page).to have_content('24/07/2021')
    expect(page).to have_content('17/06/2021')
    expect(page).to have_content('Boleto')
    expect(page).to_not have_content('Cliente final 2')
    expect(page).to_not have_content('Produto 2')
    expect(page).to_not have_content('R$ 60,00')
    expect(page).to_not have_content('R$ 9,00')
    expect(page).to_not have_content('R$ 51,00')
    expect(page).to_not have_content('15/06/2021')
    expect(page).to_not have_content('15/06/2021')
    expect(page).to_not have_content('Cartão de Crédito MasterChef')
    expect(page).to_not have_content('Cliente final 3')
    expect(page).to_not have_content('Produto 2')
    expect(page).to_not have_content('R$ 70,00')
    expect(page).to_not have_content('R$ 7,00')
    expect(page).to_not have_content('R$ 63,00')
    expect(page).to_not have_content('14/06/2021')
    expect(page).to_not have_content('14/06/2021')
    expect(page).to_not have_content('PIX')
  end
  it 'failure' do
    PaymentCompany.create!(company: company, payment_option: pay_boleto1)
    HistoricProduct.create(product: product, company: company, price: product.price)
    CompanyClient.create!(company: company, final_client: final_client)
    Receipt.create!(due_deadline: charge1.due_deadline, payment_date: charge1.payment_date, charge: charge1,
                    authorization_token: 'nn9e32jnvaç')
    boleto1 = boleto
    cc = credit_card
    pix1 = pix

    visit root_path
    click_on 'Recibos'
    fill_in 'Token de autorização',	with: '11111'
    click_on 'Procurar'

    expect(page).to have_content('Nenhum recibo encontrado')
  end
end
