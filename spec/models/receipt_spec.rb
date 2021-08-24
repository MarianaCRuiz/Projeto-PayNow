require 'rails_helper'

describe Receipt do
  context 'validation' do
    it 'cannot be blank' do
      receipt = Receipt.new
      receipt.valid?
      expect(receipt.errors[:payment_date]).to include('não pode ficar em branco')
      expect(receipt.errors[:authorization_token]).to include('não pode ficar em branco')
    end
  end
end
