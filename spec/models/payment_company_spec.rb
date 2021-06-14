require 'rails_helper'

describe PaymentCompany do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:company_2) {Company.create!(corporate_name: 'Empresa SA', cnpj: '11.888.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@empresa.com')}
  let(:pay_1) {PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)}

  context 'uniq scope company' do
    it 'same company' do
      PaymentCompany.create!(company: company, payment_option: pay_1)
      pay = PaymentCompany.new(company: company, payment_option: pay_1)

      pay.valid?
      expect(pay.errors[:payment_option]).to include('já está em uso') 
    end
    it 'different companies' do
      PaymentCompany.create!(company: company_2, payment_option: pay_1)
      pay = PaymentCompany.new(company: company, payment_option: pay_1)

      pay.valid?
      expect(pay.errors.count).to eq(0) 
    end
  end
end

