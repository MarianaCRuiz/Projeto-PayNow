Admin.create!(email: 'adminteste1@paynow.com.br', permitted: 0)
Admin.create!(email: 'adminteste2@paynow.com.br', permitted: 0)
Admin.create!(email: 'adminteste3@paynow.com.br', permitted: 1)

company_1 = Company.create!(corporate_name: 'Codeplay SA', cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                            city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                            address_complement: '', billing_email: 'person1@codeplay.com')
DomainRecord.create!(email: 'user1@codeplay.com', domain: 'codeplay.com')
User.create!(email:'user2@codeplay.com', password: '123456', role: 0, company: company_1)
User.create!(email:'user1@codeplay.com', password: '123456', role: 1, company: company_1)

company_2 = Company.create!(corporate_name: 'Empresa1 SA', cnpj: '44.212.343/0001-42' , state: 'São Paulo', 
                            city: 'Campinas', district: 'Csmpos', street: 'rua 2', number: '13', 
                            address_complement: '', billing_email: 'person1@empresa1.com')
DomainRecord.create!(email: 'user1@empresa1.com', domain: 'empresa1.com')
User.create!(email:'user2@empresa1.com', password: '123456', role: 0, company: company_2)
User.create!(email:'user1@empresa1.com', password: '123456', role: 1, company: company_2)

pay_1 = PaymentOption.create!(name: 'Boleto', fee: 1.9, max_money_fee: 20)
pay_2 = PaymentOption.create!(name: 'PIX', fee: 1.3, max_money_fee: 21)
pay_3 = PaymentOption.create!(name: 'Cartão de Crédito MasterChef', fee: 1.2, max_money_fee: 24)

BoletoRegisterOption.create!(company: company_1, name: pay_1.name, bank_code: '001', agency_number: '2050', account_number: '123.555-8')
CreditCardRegisterOption.create!(company: company_1, name: pay_3.name, credit_card_operator_token: SecureRandom.base58(20))
PixRegisterOption.create!(company: company_1, name: pay_2.name, pix_key: SecureRandom.base58(20), bank_code: '001')


# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
