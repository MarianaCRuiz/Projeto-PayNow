require 'rails_helper'

describe 'client_admin deactivate credit card option' do
  let(:company) do
    Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44', state: 'São Paulo',
                    city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12',
                    address_complement: '', billing_email: 'faturamento@codeplay.com')
  end
  let(:user_admin) { User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company) }
  let(:pay_creditcard1) do
    PaymentOption.create!(name: 'Cartão de Crédito PISA', fee: 1.9, max_money_fee: 20, payment_type: 1)
  end
  let(:pay4) { PaymentOption.create!(name: 'Cartão de Crédito MAIN', fee: 1.7, max_money_fee: 22, payment_type: 1) }
  let(:bank) { BankCode.create!(code: '001', bank: 'Banco do Brasil S.A.') }
  let(:product) { Product.create!(name: 'Produto 1', price: 50, boleto_discount: 10, company: company) }
  let(:final_client) { FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599') }
  let(:creditcard) do
    CreditCardRegisterOption.create!(company: company, payment_option: pay_creditcard1,
                                     credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
  end
  let(:status_charge) { StatusCharge.create!(code: '01', description: 'Pendente de cobrança') }

  it 'client_admin deactivate credit card succesfully' do
    PaymentCompany.create(company: company, payment_option: pay_creditcard1)
    PaymentCompany.create(company: company, payment_option: pay4)
    CreditCardRegisterOption.create!(company: company, payment_option: pay4,
                                     credit_card_operator_token: 'jdB83Nmg8fR1PJA612dr')
    DomainRecord.find_by(email_client_admin: user_admin.email).update!(company: company)
    Charge.create!(client_token: final_client.token, client_name: final_client.name, client_cpf: final_client.cpf,
                   company_token: company.token, product_token: product.token,
                   payment_method: pay_creditcard1.name, card_number: '1111 2222 3333 4444',
                   card_name: 'CLIENTE X2', cvv_code: '123', due_deadline: '20/08/2021',
                   company: company, final_client: final_client,
                   status_charge: status_charge, product: product,
                   payment_option: pay_creditcard1, price: product.price, charge_price: 45,
                   product_name: product.name, discount: 5)

    creditcard
    pay = pay_creditcard1.name

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on "Excluir #{pay}"

    expect(page).to have_content('Meio de pagamento excluído com sucesso')
    expect(page).to_not have_content(creditcard.credit_card_operator_token)
  end
end
