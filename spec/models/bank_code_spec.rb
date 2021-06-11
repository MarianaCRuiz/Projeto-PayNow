require 'rails_helper'

describe BankCode do
  it 'code must be uniq' do
    BankCode.create(code: '001', bank: 'Banco BB')
    bank = BankCode.new(code: '001', bank: 'Itaú')
    
    bank.valid?

    expect(bank.errors[:code]).to include('já está em uso') 
  end
end
