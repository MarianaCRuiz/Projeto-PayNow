require 'rails_helper'

describe 'payment options' do
  context 'register successfully' do
    xit 'boleto' do
    end
    xit 'PIX' do
    end
    xit 'creditcard' do
    end
  end
  context 'register failure' do
    xit 'boleto missing information' do
    end
    xit 'PIX missing information' do
    end
    xit 'creditcard missing information' do
    end
  end
  context 'deactivated option' do
    xit 'must be logged in' do
    end
    xit 'cannot show boleto deactivated' do
    end
    xit 'cannot show PIX deactivated' do
    end
    xit 'cannot show creditcard deactivated' do
    end
  end
end