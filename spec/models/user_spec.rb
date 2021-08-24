require 'rails_helper'

describe User do
  it 'save an email just once' do
    company1 = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44',
                               state: 'São Paulo', city: 'Campinas', district: 'Inova',
                               street: 'rua 1', number: '12', address_complement: '',
                               billing_email: 'person1@codeplay.com')
    User.create!(email: 'user1@codeplay.com', password: '123456', role: 0, company: company1)
    user = User.new(email: 'user1@codeplay.com', password: '123456', role: 1, company: company1)

    user.valid?

    expect(user.errors[:email]).to include('já está em uso')
  end
  it 'email cannot be public account' do
    company1 = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44',
                               state: 'São Paulo', city: 'Campinas', district: 'Inova',
                               street: 'rua 1', number: '12', address_complement: '',
                               billing_email: 'person1@codeplay.com')
    user = User.new(email: 'user1@gmail.com', password: '123456', role: 1, company: company1)

    user.valid?

    expect(user.errors.count).to eq(1)
  end
end
