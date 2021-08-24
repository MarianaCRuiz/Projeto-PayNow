require 'rails_helper'

describe DomainRecord do
  context 'save an email just once' do
    it 'email_client_admin' do
      DomainRecord.create!(email_client_admin: 'user1@codeplay.com', domain: 'codeplay.com')
      domain = DomainRecord.new(email_client_admin: 'user1@codeplay.com', domain: 'codeplay.com')

      domain.valid?
      expect(domain.errors[:email_client_admin]).to include('já está em uso')
    end
    it 'email' do
      DomainRecord.create!(email: 'user2@codeplay.com', domain: 'codeplay.com')
      domain = DomainRecord.new(email: 'user2@codeplay.com', domain: 'codeplay.com')

      domain.valid?
      expect(domain.errors[:email]).to include('já está em uso')
    end
  end
end
