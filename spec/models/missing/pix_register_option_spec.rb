require 'rails_helper'

describe PixRegisterOption do
  context 'validation' do    "pix_key" "bank_code"
    it 'attributes cannot be blank' do
      pix_register = PixRegisterOption.new
      pix_register.valid?
      expect(pix_register.errors[:pix_key]).to include('não pode ficar em branco')
      expect(pix_register.errors[:bank_code]).to include('não pode ficar em branco')
    end
    it 'key must be uniq in the company' do
      bank = BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')
      company_1 = Company.create!(corporate_name: 'test SA', cnpj: '11.222.333/0001-45' , 
                                  state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                  street: 'rua 1', number: '12', address_complement: '', 
                                  billing_email: 'persontest@test.com')
      pix_1 = PixRegisterOption.create!(pix_key: 'as3DV98Bh7Hg12CgAapd', 
                                        bank_code: bank,
                                        company: company_1)
      pix_2 = PixRegisterOption.new(pix_key: 'as3DV98Bh7Hg12CgAapd', 
                                    bank_code: bank,
                                    company: company_1)
      pix_2.valid?

      expect(pix_2.errors[:pix_key]).to include('já está em uso') 
    end
    it 'must be uniq just in the same company' do
      bank = BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')
      company_1 = Company.create!(corporate_name: 'test SA', cnpj: '11.222.333/0001-45' , 
                                  state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                  street: 'rua 1', number: '12', address_complement: '', 
                                  billing_email: 'persontest@test.com')
      company_2 = Company.create!(corporate_name: 'test_1 SA', cnpj: '11.222.555/0001-45' , 
                                  state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                  street: 'rua 1', number: '12', address_complement: '', 
                                  billing_email: 'persontest@test1.com')
      pix_1 = PixRegisterOption.create!(pix_key: 'as3DV98Bh7Hg12CgAapd', 
                                        bank_code: bank,
                                        company: company_1)
      pix_2 = PixRegisterOption.new(pix_key: 'as3DV98Bh7Hg12CgAapd', 
                                    bank_code: bank,
                                    company: company_2)
      pix_2.valid?

      expect(pix_2.errors.count).to eq(0) 
    end
  end
end
