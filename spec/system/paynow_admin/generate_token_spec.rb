require 'rails_helper'

describe 'generate token' do
  let(:user) {User.create!(email: 'admin1@paynow.com.br', password: '123456', password_confirmation: '123456', role: 'admin')}
  context 'company token' do
    xit 'generate token' do
      Admin.create!(email: 'admin1@paynow.com.br')
      
      login_as user, scope: :user
      

    end
    xit 'generate new token by client_admin request' do
    end
  end
  context 'product token' do
    xit 'generate token' do
    end
    xit 'generate new token by client_admin request' do
    end
  end
end