require 'rails_helper'

describe BoletoRegisterOption do
  context 'validation' do
    it 'attributes cannot be blank' do
      boleto_register = BoletoRegisterOption.new
      boleto_register.valid?

      expect(boleto_register.errors[:agency_number]).to include('não pode ficar em branco')
      expect(boleto_register.errors[:bank_code_id]).to include('não pode ficar em branco')
      expect(boleto_register.errors[:account_number]).to include('não pode ficar em branco')
    end
    it 'account_number must be uniq in the company' do
      pay_1 = PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20)
      bank = BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')
      company_1 = Company.create!(corporate_name: 'test SA', cnpj: '11.222.333/0001-45' , 
                                  state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                  street: 'rua 1', number: '12', address_complement: '', 
                                  billing_email: 'persontest@test.com')
      company_2 = Company.new(corporate_name: 'test 2 SA', cnpj: '11.000.333/0001-45' , 
                              state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                              street: 'rua 1', number: '12', address_complement: '', 
                              billing_email: 'persontest@test2.com')

      boleto_1 = BoletoRegisterOption.create!(company: company_1, name: pay_1.name, bank_code: bank, 
                                              agency_number: '2050', account_number: '123.555-8')
      boleto_2 = BoletoRegisterOption.new(company: company_2, name: pay_1.name, bank_code: bank, 
                                              agency_number: '2050', account_number: '123.555-8')
      boleto_2.valid?

      expect(boleto_2.errors[:account_number]).to include('já está em uso') 
    end
    it 'must be uniq just in the same bank in the same company' do
      pay_1 = PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20)
      bank1 = BankCode.create!(code: '001', bank: 'Banco do Brasil S.A.')
      bank2 = BankCode.create!(code: '063', bank: 'Banco Bradescard S.A.')
      company_1 = Company.create!(corporate_name: 'test SA', cnpj: '11.222.333/0001-45' , 
                                  state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                  street: 'rua 1', number: '12', address_complement: '', 
                                  billing_email: 'persontest@test.com')
      
      boleto_1 = BoletoRegisterOption.create!(company: company_1, name: pay_1.name, bank_code: bank1, 
                                              agency_number: '2050', account_number: '123.555-8')
      boleto_2 = BoletoRegisterOption.new(company: company_1, name: pay_1.name, bank_code: bank2, 
                                              agency_number: '2050', account_number: '123.555-8')
      boleto_2.valid?

      expect(boleto_2.errors.count).to eq(0) 
    end
    xit 'do not need to be uniq if different companies' do
      pay_1 = PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20)
      bank1 = BankCode.create!(code: '001', bank: 'Banco do Brasil S.A.')
      bank2 = BankCode.create!(code: '063', bank: 'Banco Bradescard S.A.')
      company_1 = Company.create!(corporate_name: 'test SA', cnpj: '11.222.333/0001-45' , 
                                  state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                  street: 'rua 1', number: '12', address_complement: '', 
                                  billing_email: 'persontest@test.com')
      company_2 = Company.new(corporate_name: 'test 2 SA', cnpj: '11.000.333/0001-45' , 
                              state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                              street: 'rua 1', number: '12', address_complement: '', 
                              billing_email: 'persontest@test2.com')            
      
      boleto_1 = BoletoRegisterOption.create!(company: company_1, name: pay_1.name, bank_code: bank1, 
                                              agency_number: '2050', account_number: '123.555-8')
      boleto_2 = BoletoRegisterOption.new(company: company_2, name: pay_1.name, bank_code: bank1, 
                                              agency_number: '1390', account_number: '123.555-8')
      boleto_2.valid?

      expect(boleto_2.errors.count).to eq(0) 
    end
  end
end

