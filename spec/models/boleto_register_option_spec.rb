require 'rails_helper'

describe BoletoRegisterOption do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                  city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                  address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:boleto) {BoletoRegisterOption.new(company: company, payment_option: pay_boleto_1, bank_code: bank,
                                         agency_number: '2050', account_number: '123.555-8')}
  let(:pay_boleto_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  let(:bank2) {BankCode.create!(code: '029', bank:'Itau')}
  
  it 'attributes cannot be blank' do
    boleto = BoletoRegisterOption.new
    boleto.valid?

    expect(boleto.errors[:bank_code]).to include('é obrigatório(a)')
    expect(boleto.errors[:agency_number]).to include('não pode ficar em branco')
    expect(boleto.errors[:account_number]).to include('não pode ficar em branco')
  end
  it 'must be uniq scope agency and bank' do
    BoletoRegisterOption.create!(company: company, payment_option: pay_boleto_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
    boleto_2 = BoletoRegisterOption.new(company: company, payment_option: pay_boleto_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
    boleto_2.valid?

    expect(boleto_2.errors[:account_number]).to include('já está em uso')    
  end
  it 'do not need to be uniq scope just agency, different bank' do
    BoletoRegisterOption.create!(company: company, payment_option: pay_boleto_1, bank_code: bank, agency_number: '2050', account_number: '123.555-8')
    boleto_2 = BoletoRegisterOption.new(company: company, payment_option: pay_boleto_1, bank_code: bank2, agency_number: '2050', account_number: '123.555-8')
    boleto_2.valid?

    expect(boleto_2.errors).to be_empty  
  end
end       
