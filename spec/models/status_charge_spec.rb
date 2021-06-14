require 'rails_helper'

describe StatusCharge do
  it 'cannot be blank' do
    status_charge = StatusCharge.new
    
    status_charge.valid?

    expect(status_charge.errors[:code]).to include('não pode ficar em branco') 
    expect(status_charge.errors[:description]).to include('não pode ficar em branco') 
  end
  it ' must be uniq' do
    StatusCharge.create!(code: '20', description: 'alguma coisa')
    status_charge = StatusCharge.new(code: '20', description: 'alguma coisa')
    
    status_charge.valid?

    expect(status_charge.errors[:code]).to include('já está em uso') 
    expect(status_charge.errors[:description]).to include('já está em uso') 
  end
end
