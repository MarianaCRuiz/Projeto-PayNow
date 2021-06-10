require 'rails_helper'

describe 'clients accounts from a registered company' do
  let(:user_client) {User.create!(email:'user2@codeplay.com', password: '123456', role: 2)}
  context 'client register' do
    it 'successfully' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                      city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                      address_complement: '', billing_email: 'person1@codeplay.com')
      rec = DomainRecord.create!(email_client_admin: 'user1@codeplay.com', domain: 'codeplay.com', company_id: company.id)

      visit root_path
      click_on 'Registrar-se'
      fill_in 'Email', with: 'user2@codeplay.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      expect{ click_on 'Criar conta' }.to change{ User.count }.by(1)
      
      expect(page).to have_content('user2@codeplay.com')
      expect(page).to have_link('Codeplay SA')
      expect(User.last.company).to eq(company)
    end
    xit 'cannot be blank' do
      company = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                                address_complement: '', billing_email: 'person1@codeplay.com')
      rec = DomainRecord.create!(email_client_admin: 'user1@codeplay.com', domain: 'codeplay.com', company_id: company.id)

      visit root_path
      click_on 'Registrar-se'
      fill_in 'Email', with: 'user2@codeplay.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      expect{ click_on 'Criar conta' }.to change{ User.count }.by(1)
      
      expect(page).to have_content('user2@codeplay.com')
    end
    xit 'already registered' do
    end
    xit 'cannot be a public domain' do
    end
  end
  context 'client edit' do
    xit 'successfully' do
    end
    xit 'email cannot be a public domain' do
    end
    xit 'cannot be blank' do
    end
  end
  context 'client delete' do
    xit 'successfully' do
    end
  end
end