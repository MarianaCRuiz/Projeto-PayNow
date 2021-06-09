require 'rails_helper'

describe 'company' do
  context 'POST' do
    xit 'just client admin can create company' do
    end
    xit 'just client admin can update company' do
    end
    xit 'token must be uniq' do   #sei lá.....
      company_1 = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                  city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                  address_complement: '', billing_email: 'person1@codeplay.com')

      company_1.token = 'ps34JD2d83BFhs8DbY8v'

      post "/client_admin/companies", params: {company: {corporate_name: 'Empresa1 SA', 
                                            cnpj: '44.212.343/0001-42' , state: 'São Paulo', 
                                            city: 'Campinas', district: 'Csmpos', street: 'rua 2', 
                                            number: '13', address_complement: '', 
                                            billing_email: 'person1@empresa1.com', 
                                            token: 'ps34JD2d83BFhs8DbY8v'}}
    end
  end
  context 'GET' do
    xit 'client_admin not logged cannot access company profile' do
    end
    xit 'client not logged cannot access company profile' do
    end
    xit 'just users from company or admin can access company profile' do
    end
  end
end
        