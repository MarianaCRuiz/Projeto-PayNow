require 'rails_helper'

describe PixRegisterOption do
  let(:company) {Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                  city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                  address_complement: '', billing_email: 'faturamento@codeplay.com')}
  let(:pix) {PixRegisterOption.new(company: company, payment_option: pay_2, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)}
  let(:pay_2) {PaymentOption.create!(name: 'Pix', fee: 1.9, max_money_fee: 20, payment_type: 1)}
  let(:bank) {BankCode.create!(code: '001', bank:'Banco do Brasil S.A.')}
  
  it 'attributes cannot be blank' do
    pix = PixRegisterOption.new
    pix.valid?

    expect(pix.errors[:company_id]).to include('não pode ficar em branco')
    expect(pix.errors[:payment_option_id]).to include('não pode ficar em branco')
    expect(pix.errors[:bank_code_id]).to include('não pode ficar em branco')
    expect(pix.errors[:pix_key]).to include('não pode ficar em branco')
  end
  it 'pix_operator_token must be uniq scope company' do
    PixRegisterOption.create!(company: company, payment_option: pay_2, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)
    pix_2 = PixRegisterOption.new(company: company, payment_option: pay_2, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank)
    pix_2.valid?

    expect(pix_2.errors[:pix_key]).to include('já está em uso')    
  end
end     
