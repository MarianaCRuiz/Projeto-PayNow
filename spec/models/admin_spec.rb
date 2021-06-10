require 'rails_helper'

describe Admin do
  it 'save an email just once' do
    Admin.create!(email: 'adminteste1@paynow.com.br', permitted: 0)
    admin = Admin.new(email: 'adminteste1@paynow.com.br', permitted: 0)
      
    admin.valid?
    expect(admin.errors[:email]).to include('já está em uso')   
  end
  it 'domin must be @paynow.com.br' do
    admin = Admin.new(email: 'adminteste2@teste.com.br', permitted: 0)
      
    admin.valid?
    
    expect(admin.errors[:email]).to include('dominio deve ser paynow.com.br')   
  end
end
