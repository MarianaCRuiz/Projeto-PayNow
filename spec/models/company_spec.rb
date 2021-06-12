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
      company_1 = Company.create!(corporate_name: 'test SA', cnpj: '11.222.333/0001-45' , 
                                  state: 'São Paulo', city: 'Campinas', district: 'Inova', 
                                  street: 'rua 1', number: '12', address_complement: '', 
                                  billing_email: 'persontest@test.com')
      company_2 = Company.new(corporate_name: 'test SA', cnpj: '11.222.333/0001-45' , 
                                  state: 'São Paulo', city: 'Campinas', district: 'Campos', 
                                  street: 'rua 2', number: '13', address_complement: '', 
                                  billing_email: 'persontest@test.com')

      company_2.valid?

      expect(company_2.errors[:corporate_name]).to include('já está em uso') 
      expect(company_2.errors[:cnpj]).to include('já está em uso') 
      expect(company_2.errors[:billing_email]).to include('já está em uso')   
    end
    xit 'must have a token created' do
      
    end
  end
  context 'validates_associated' do
    xit 'users' do
      
    end
  end
end


#describe Enrollment do
#  let(:student) {Student.create!(email:'teste7@gmail.com', password: '123456')}
#  it 'and cannot buy a company twice' do
#    instructor = Instructor.create!(name: 'Tico') 
#    company = Course.create!(name: 'Ruby', description: 'Um curso de Ruby')
#    Enrollment.create!(company_id: company.id, price: 10, student_id: student.id)     
#    enrollment = Enrollment.new(company_id: company.id, price: 18, student_id: student.id)
  
#    enrollment.valid?
    
#    expect(enrollment.errors[:company]).to include("Não pode comprar duas vezes")

#  end
#end