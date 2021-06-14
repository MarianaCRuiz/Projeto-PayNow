require 'rails_helper'

describe BankCode do
  it 'code must be uniq' do
    BankCode.create!(code: '567', bank: 'Banco x')
    bank = BankCode.new(code: '567', bank: 'Banco x')
    
    bank.valid?

    expect(bank.errors[:code]).to include('já está em uso') 
  end
end
