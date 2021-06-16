require 'rails_helper'

describe Product do
  let(:company) {Company.create!(corporate_name: 'Empresa 3 SA', cnpj: '11.222.333/0001-55' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'faturamento@empresa3.com')}
  
  it 'cannot be blank' do
    product = Product.new(name: '', price: '', company: company)
      
    product.valid?

    expect(product.errors[:name]).to include('não pode ficar em branco')
    expect(product.errors[:price]).to include('não pode ficar em branco')   
  end
  it 'cannot be negative' do
    product = Product.new(boleto_discount: -1, credit_card_discount: -1, pix_discount: -1)
      
    product.valid?

    expect(product.errors[:boleto_discount]).to include('deve ser maior ou igual a 0.0')
    expect(product.errors[:credit_card_discount]).to include('deve ser maior ou igual a 0.0')
    expect(product.errors[:pix_discount]).to include('deve ser maior ou igual a 0.0')   
  end
  it 'name uniq same company' do
    Product.create!(name: 'Produto 1', price: 10, company: company)
    product = Product.new(name: 'Produto 1', price: 12, company: company)
        
    product.valid?
    
    expect(product.errors[:name]).to include('Produto já cadastrado')  
  end 
  it 'name not uniq different companies' do
    company2 = Company.create!(corporate_name: 'Empresa 4 SA', cnpj: '11.222.333/0001-58' , state: 'São Paulo', 
                               city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                               address_complement: '', billing_email: 'faturamento@empresa4.com')
    Product.create!(name: 'Produto 1', price: 10, company: company2)
    product = Product.new(name: 'Produto 1', price: 12, company: company)
        
    product.valid?

    expect(product.errors.count).to be(0)  
  end 
end
