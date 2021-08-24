require 'rails_helper'

describe PaymentOption do
  it 'cannot be blank' do
    payment = PaymentOption.new(name: '', fee: '', max_money_fee: '')

    payment.valid?

    expect(payment.errors[:name]).to include('não pode ficar em branco')
    expect(payment.errors[:fee]).to include('não pode ficar em branco')
    expect(payment.errors[:max_money_fee]).to include('não pode ficar em branco')
  end

  it 'name uniq' do
    PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20)
    payment = PaymentOption.new(name: 'Boleto', fee: 1.0, max_money_fee: 20)

    payment.valid?

    expect(payment.errors[:name]).to include('já está em uso')
  end
end
