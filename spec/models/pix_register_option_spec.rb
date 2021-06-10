require 'rails_helper'

describe PixRegisterOption do

  context 'validation' do
    it 'attributes cannot be blank' do
      pix_register = PixRegisterOption.new
      
      pix_register.valid?

      expect(pix_register.errors[:pix_key]).to include('não pode ficar em branco')
      expect(pix_register.errors[:bank_code_id]).to include('não pode ficar em branco')
    end
    it 'key must be uniq in the company' do
      pay_2 = PaymentOption.create!(name: 'PIX', fee: 1.3, max_money_fee: 21)
      bank = BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')
      company_1 = Company.create!(corporate_name: 'test SA', cnpj: '11.222.333/0001-45' , 
                                  state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                  street: 'rua 1', number: '12', address_complement: '', 
                                  billing_email: 'persontest@test.com')
      pix_1 = PixRegisterOption.create!(company: company_1, name: pay_2.name, 
                                        pix_key: 'as3DV98Bh7Hg12CgAapd', bank_code: bank)
      pix_2 = PixRegisterOption.new(company: company_1, name: pay_2.name, 
                                    pix_key: 'as3DV98Bh7Hg12CgAapd', bank_code: bank)
      pix_2.valid?

      expect(pix_2.errors[:pix_key]).to include('já está em uso') 
    end
    it 'must be uniq just in the same company' do
      pay_2 = PaymentOption.create!(name: 'PIX', fee: 1.3, max_money_fee: 21)
      bank = BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')
      company_1 = Company.create!(corporate_name: 'test SA', cnpj: '11.222.333/0001-45' , 
                                  state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                  street: 'rua 1', number: '12', address_complement: '', 
                                  billing_email: 'persontest@test.com')
      company_2 = Company.create!(corporate_name: 'test_1 SA', cnpj: '11.222.555/0001-45' , 
                                  state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                  street: 'rua 1', number: '12', address_complement: '', 
                                  billing_email: 'persontest@test1.com')
      pix_1 = PixRegisterOption.create!(name: pay_2.name, 
                                        pix_key: 'as3DV98Bh7Hg12CgAapd', 
                                        bank_code: bank,
                                        company: company_1)
      pix_2 = PixRegisterOption.new(name: pay_2.name,
                                    pix_key: 'as3DV98Bh7Hg12CgAapd', 
                                    bank_code: bank,
                                    company: company_2)
      pix_2.valid?

      expect(pix_2.errors.count).to eq(0) 
    end
  end
end
