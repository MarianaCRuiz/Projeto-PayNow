require 'rails_helper'

describe CreditCardRegisterOption do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                  city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                  address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:credit_card) {CreditCardRegisterOption.new(company: company, payment_option: pay_2, bank_code: bank,
                                         agency_number: '2050', account_number: '123.555-8')}
  let(:pay_2) {PaymentOption.create!(name: 'CreditCard', fee: 1.9, max_money_fee: 20, payment_type: 1)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  
  it 'attributes cannot be blank' do
    credit_card = CreditCardRegisterOption.new
    credit_card.valid?

    expect(credit_card.errors[:company_id]).to include('não pode ficar em branco')
    expect(credit_card.errors[:payment_option_id]).to include('não pode ficar em branco')
    expect(credit_card.errors[:credit_card_operator_token]).to include('não pode ficar em branco')
  end
  it 'credit_card_operator_token must be uniq scope company' do
    CreditCardRegisterOption.create!(company: company, payment_option: pay_2, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
    credit_card_2 = CreditCardRegisterOption.new(company: company, payment_option: pay_2, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
    credit_card_2.valid?

    expect(credit_card_2.errors[:credit_card_operator_token]).to include('já está em uso')    
  end
end     