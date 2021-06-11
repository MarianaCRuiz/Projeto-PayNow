require 'rails_helper'

describe CreditCardRegisterOption do
  context 'validation' do
    it 'attributes cannot be blank' do
      credit_card_register_oprtion = CreditCardRegisterOption.new
      credit_card_register_oprtion.valid?
      expect(credit_card_register_oprtion.errors[:credit_card_operator_token]).to include('não pode ficar em branco')
    end
    it ' must be uniq in the company' do
      company_1 = Company.create!(corporate_name: 'test SA', cnpj: '11.222.333/0001-45' , 
                                  state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                  street: 'rua 1', number: '12', address_complement: '', 
                                  billing_email: 'persontest@test.com')
      credit_card_1 = CreditCardRegisterOption.create!(credit_card_operator_token: 'as3DV98Bh7Hg12CgAapd', 
                                                        company: company_1)
      credit_card_2 = CreditCardRegisterOption.new(credit_card_operator_token: 'as3DV98Bh7Hg12CgAapd', 
                                                      company: company_1)
      credit_card_2.valid?

      expect(credit_card_2.errors[:credit_card_operator_token]).to include('já está em uso') 
    end
    it 'must be uniq just in the same company' do
      company_1 = Company.create!(corporate_name: 'test SA', cnpj: '11.222.333/0001-45' , 
                                  state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                  street: 'rua 1', number: '12', address_complement: '', 
                                  billing_email: 'persontest@test.com')
      company_2 = Company.create!(corporate_name: 'test_1 SA', cnpj: '11.222.555/0001-45' , 
                                  state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                  street: 'rua 1', number: '12', address_complement: '', 
                                  billing_email: 'persontest@test1.com')
      credit_card_1 = CreditCardRegisterOption.create!(credit_card_operator_token: 'as3DV98Bh7Hg12CgAapd', 
                                                        company: company_1)
      credit_card_2 = CreditCardRegisterOption.new(credit_card_operator_token: 'as3DV98Bh7Hg12CgAapd', 
                                                      company: company_2)
      credit_card_2.valid?

      expect(credit_card_2.errors.count).to eq(0) 
    end
  end
end
