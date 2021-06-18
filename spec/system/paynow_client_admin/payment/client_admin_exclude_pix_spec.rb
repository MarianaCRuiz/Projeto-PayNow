require 'rails_helper'

describe 'client_admin deactivate credit card option' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:user_admin) {User.create!(email: 'admin@codeplay.com', password: '123456', role: 1, company: company)}
  let(:pay_3) {PaymentOption.create!(name: 'PIX_1', fee: 1.9, max_money_fee: 20, payment_type: 2)}
  let(:pay_4) {PaymentOption.create!(name: 'PIX_2', fee: 1.7, max_money_fee: 22, payment_type: 2)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  let(:product) {Product.create!(name:'Produto 1', price: 50, boleto_discount: 10, company: company)}
  let(:final_client) {FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599')}
  let(:pix) {PixRegisterOption.create!(company: company, payment_option: pay_3, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)}
  let(:status_charge) {StatusCharge.create!(code: '01', description: 'Pendente de cobrança')}
  
  it 'client_admin deactivate credit card succesfully' do
    PaymentCompany.create(company: company, payment_option: pay_3)
    PaymentCompany.create(company: company, payment_option: pay_4)
    pix2 = PixRegisterOption.create!(company: company, payment_option: pay_4, pix_key: 'HSBCU6874bGABPEH62B2', bank_code: bank)
    DomainRecord.create!(email_client_admin: user_admin.email, domain: 'empresa3.com', company: company)
    c1 = Charge.create!(client_token: final_client.token, client_name: final_client.name, 
                         client_cpf: final_client.cpf, company_token:company.token, 
                         product_token: product.token, payment_method: pay_3.name, 
                         due_deadline: '20/08/2021', company: company, final_client: final_client,
                         status_charge: status_charge, product: product,
                         payment_option: pay_3, price: product.price, charge_price: 45,
                         product_name: product.name, discount: 5)
                  
    pix1 = pix
    pay = pay_3.name
    

    login_as user_admin, scope: :user
    visit client_admin_company_path(company[:token])
    click_on 'Opções de pagamento'
    click_on "Excluir #{pay}"

    expect(page).to have_content('Meio de pagamento excluído com sucesso')  
    expect(page).to_not have_content(pix.pix_key)
    expect(page).to have_content(pix2.pix_key)
  end
end