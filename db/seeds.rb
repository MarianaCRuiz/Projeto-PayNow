Admin.create!(email: 'adminteste1@paynow.com.br', permitted: 0)
Admin.create!(email: 'adminteste2@paynow.com.br', permitted: 0)
Admin.create!(email: 'adminteste3@paynow.com.br', permitted: 1)
Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                address_complement: '', billing_email: 'person1@codeplay.com')
Company.create!(corporate_name: 'Empresa1 SA', cnpj: '44.212.343/0001-42' , state: 'São Paulo', 
                city: 'Campinas', district: 'Csmpos', street: 'rua 2', number: '13', 
                address_complement: '', billing_email: 'person1@empresa1.com')
DomainRecord.create!(email: 'user1@codeplay.com', domain: 'codeplay.com')
User.create!(email:'user2@codeplay.com', password: '123456', role: 0)
User.create!(email:'user1@codeplay.com', password: '123456', role: 1)
DomainRecord.create!(email: 'user1@empresa1.com', domain: 'empresa1.com')
User.create!(email:'user2@empresa1.com', password: '123456', role: 0)
User.create!(email:'user1@empresa1.com', password: '123456', role: 1)
PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20, icon: fixture_file_upload('Boleto.jpg', ('image/jpg')))



# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
