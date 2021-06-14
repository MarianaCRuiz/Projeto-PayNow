require 'rails_helper'

describe Charge do
  context 'validation' do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:product) {Product.create!(name:'Produto 1', price: 50, boleto_discount: 10, credit_card_discount: 8, company: company)}
  let(:pay_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:pay_2) {PaymentOption.create(name: 'Cartão de Crédito MasterChef', fee: 1.2, max_money_fee: 24, payment_type:1)}
  let(:pay_3) {PaymentOption.create(name: 'PIX', fee: 1.3, max_money_fee: 21, payment_type: 2)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  let(:boleto) {BoletoRegisterOption.create!(company: company, payment_option: pay_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')}
  let(:credit_card) {CreditCardRegisterOption.create!(company: company, payment_option: pay_2, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')}
  let(:pix) {PixRegisterOption.create!(company: company, payment_option: pay_3, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)}
  let(:final_client) {FinalClient.create!(name: 'Cliente final 1', cpf: '11122255599')}

    it 'attributes cannot be blank' do
      charge = Charge.new
      charge.valid?
      expect(charge.errors[:client_name]).to include('não pode ficar em branco')
      expect(charge.errors[:client_cpf]).to include('não pode ficar em branco')
      expect(charge.errors[:company_token]).to include('não pode ficar em branco')
      expect(charge.errors[:product_token]).to include('não pode ficar em branco')   
    end
    it 'attributes cannot be boleto' do
      company1 = company
      bank1 = bank
      pay1 = pay_1
      boleto1 = boleto
      product1 = product
      final_client1 = final_client
      charge = Charge.new(client_name: final_client.name, client_cpf: final_client.cpf, company_token: company.token, 
        product_token: product.token, boleto_register_option_id: boleto.id, payment_method: 'boleto')
      charge.valid?
      expect(charge.errors[:client_address]).to include('não pode ficar em branco')   
    end
    it 'attributes cannot be blank credit card' do
      company1 = company
      bank1 = bank
      pay1 = pay_1
      credit_card1 = credit_card
      product1 = product
      final_client1 = final_client
      charge = Charge.new(client_name: final_client.name, client_cpf: final_client.cpf, company_token: company.token, 
        product_token: product.token, credit_card_register_option_id: credit_card.id, payment_method: 'credit_card')
      charge.valid?
      expect(charge.errors[:card_number]).to include('não pode ficar em branco')
      expect(charge.errors[:card_name]).to include('não pode ficar em branco')
      expect(charge.errors[:cvv_code]).to include('não pode ficar em branco')
    end
  end
end