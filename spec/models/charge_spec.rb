require 'rails_helper'

describe Charge do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:pay_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}
  let(:pay_2) {PaymentOption.create!(name: 'Cartão de crédito', fee: 1.9, max_money_fee: 20, payment_type: 1)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  let(:boleto) {BoletoRegisterOption.create!(company: company, payment_option: pay_1, 
                                            bank_code: bank, agency_number: '2050', 
                                            account_number: '123.555-8')}

  context 'validation' do
    it 'presence basic data' do
      PaymentCompany.create(company: company, payment_option: pay_1)
      charge1 = Charge.new()
      charge1.valid?
      expect(charge1.errors[:client_name]).to include('não pode ficar em branco') 
      expect(charge1.errors[:client_cpf]).to include('não pode ficar em branco') 
      expect(charge1.errors[:company_token]).to include('não pode ficar em branco') 
      expect(charge1.errors[:product_token]).to include('não pode ficar em branco') 
      expect(charge1.errors[:payment_method]).to include('não pode ficar em branco') 
      expect(charge1.errors[:due_deadline]).to_not include('não pode ficar em branco')
      expect(charge1.errors[:client_address]).to_not include('não pode ficar em branco')
      expect(charge1.errors[:card_number]).to_not include('não pode ficar em branco')
      expect(charge1.errors[:card_name]).to_not include('não pode ficar em branco')
      expect(charge1.errors[:cvv_code]).to_not include('não pode ficar em branco') 
    end
    it 'presence additional data for boleto' do
      PaymentCompany.create(company: company, payment_option: pay_1)
      charge1 = Charge.new(payment_option: pay_1)
      charge1.valid?
      expect(charge1.errors[:client_name]).to include('não pode ficar em branco') 
      expect(charge1.errors[:client_cpf]).to include('não pode ficar em branco') 
      expect(charge1.errors[:company_token]).to include('não pode ficar em branco') 
      expect(charge1.errors[:product_token]).to include('não pode ficar em branco')  
      expect(charge1.errors[:due_deadline]).to include('não pode ficar em branco') 
      expect(charge1.errors[:client_address]).to include('não pode ficar em branco') 
    end
    it 'presence additional data for credit card' do
      PaymentCompany.create(company: company, payment_option: pay_2)
      charge1 = Charge.new(payment_option: pay_2)
      charge1.valid?
      expect(charge1.errors[:client_name]).to include('não pode ficar em branco') 
      expect(charge1.errors[:client_cpf]).to include('não pode ficar em branco') 
      expect(charge1.errors[:company_token]).to include('não pode ficar em branco') 
      expect(charge1.errors[:product_token]).to include('não pode ficar em branco') 
      expect(charge1.errors[:card_number]).to include('não pode ficar em branco')
      expect(charge1.errors[:card_name]).to include('não pode ficar em branco')
      expect(charge1.errors[:cvv_code]).to include('não pode ficar em branco') 
    end
    it 'presence additional data approved status' do
      PaymentCompany.create(company: company, payment_option: pay_2)
      charge1 = Charge.new(status_returned: '05')
      charge1.valid?
      expect(charge1.errors[:client_name]).to include('não pode ficar em branco') 
      expect(charge1.errors[:client_cpf]).to include('não pode ficar em branco') 
      expect(charge1.errors[:company_token]).to include('não pode ficar em branco') 
      expect(charge1.errors[:product_token]).to include('não pode ficar em branco') 
      expect(charge1.errors[:payment_date]).to include('não pode ficar em branco')
    end
    it 'presence additional data for payment failure' do
      PaymentCompany.create(company: company, payment_option: pay_2)
      charge1 = Charge.new(status_returned: '11')
      charge1.valid?
      expect(charge1.errors[:client_name]).to include('não pode ficar em branco') 
      expect(charge1.errors[:client_cpf]).to include('não pode ficar em branco') 
      expect(charge1.errors[:company_token]).to include('não pode ficar em branco') 
      expect(charge1.errors[:product_token]).to include('não pode ficar em branco') 
      expect(charge1.errors[:attempt_date]).to include('não pode ficar em branco')
    end
  end
end