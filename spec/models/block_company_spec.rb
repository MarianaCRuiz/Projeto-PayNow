require 'rails_helper'

describe BlockCompany do
  context 'validation' do
    it 'first block admin email' do
      a1 = Admin.create(email: 'adminteste1@paynow.com.br')
      company1 = Company.create!(corporate_name: 'test SA', cnpj: '11.222.333/0001-45',
                                 state: 'São Paulo', city: 'Campinas', district: 'Inova',
                                 street: 'rua 1', number: '12', address_complement: '',
                                 billing_email: 'persontest@test.com')
      b = BlockCompany.new(company: company1, email1: a1.email, vote1: false)
      b.valid?
      expect(b.errors.count).to eq(0)
    end
    it 'second block admin email' do
      a1 = Admin.create(email: 'adminteste1@paynow.com.br')
      a2 = Admin.create(email: 'adminteste2@paynow.com.br')
      company1 = Company.create!(corporate_name: 'test SA', cnpj: '11.222.333/0001-45',
                                 state: 'São Paulo', city: 'Campinas', district: 'Inova',
                                 street: 'rua 1', number: '12', address_complement: '',
                                 billing_email: 'persontest@test.com')
      b = BlockCompany.create!(company: company1, email1: a1.email, vote1: false)
      b.email2 = a2.email
      b.vote2 = false
      b.valid?
      expect(b.errors.count).to eq(0)
    end
    it 'emails must be different' do
      a1 = Admin.create(email: 'adminteste1@paynow.com.br')
      company1 = Company.create!(corporate_name: 'test SA', cnpj: '11.222.333/0001-45',
                                 state: 'São Paulo', city: 'Campinas', district: 'Inova',
                                 street: 'rua 1', number: '12', address_complement: '',
                                 billing_email: 'persontest@test.com')
      b = BlockCompany.create!(company: company1, email1: a1.email, vote1: false)
      b.email2 = a1.email
      b.vote2 = false
      b.valid?
      expect(b.errors[:base]).to include('são necessários dois administradores diferentes para bloquear uma empresa')
    end
  end
end
