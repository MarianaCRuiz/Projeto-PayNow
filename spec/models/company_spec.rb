require 'rails_helper'

describe Company do
  context 'validation' do
    it 'attributes cannot be blank' do
      company = Company.new
      company.valid?
      expect(company.errors[:corporate_name]).to include('não pode ficar em branco')
      expect(company.errors[:cnpj]).to include('não pode ficar em branco')
      expect(company.errors[:state]).to include('não pode ficar em branco')
      expect(company.errors[:city]).to include('não pode ficar em branco')
      expect(company.errors[:district]).to include('não pode ficar em branco')
      expect(company.errors[:street]).to include('não pode ficar em branco')
      expect(company.errors[:number]).to include('não pode ficar em branco')
      expect(company.errors[:billing_email]).to include('não pode ficar em branco')
    end
    it ' must be uniq' do
      company_1 = Company.create!(corporate_name: 'test SA', cnpj: '11.222.333/0001-45',
                                  state: 'São Paulo', city: 'Campinas', district: 'Inova',
                                  street: 'rua 1', number: '12', address_complement: '',
                                  billing_email: 'persontest@test.com')
      company_2 = Company.new(corporate_name: 'test SA', cnpj: '11.222.333/0001-45',
                              state: 'São Paulo', city: 'Campinas', district: 'Campos',
                              street: 'rua 2', number: '13', address_complement: '',
                              billing_email: 'persontest@test.com')

      company_2.valid?

      expect(company_2.errors[:corporate_name]).to include('já está em uso')
      expect(company_2.errors[:cnpj]).to include('já está em uso')
      expect(company_2.errors[:billing_email]).to include('já está em uso')
    end
    it ' format' do
      company_2 = Company.new(corporate_name: 'test SA', cnpj: '43i4943i9034i43',
                              state: 'São Paulo', city: 'Campinas', district: 'Campos',
                              street: 'rua 2', number: '13', address_complement: '',
                              billing_email: 'persontest@test.com')

      company_2.valid?

      expect(company_2.errors[:cnpj]).to include('formato XX.XXX.XXX/XXXX-XX')
    end
  end
end
