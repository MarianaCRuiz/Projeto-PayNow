require 'csv'
csv_text = File.read("#{Rails.root}/public/bank_codes3.csv")
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  code, bank = row.to_s.split(' ', 2)
  BankCode.create(code: code, bank: bank)
end

email_admin_1 = 'adminteste1@paynow.com.br'
email_admin_2 = 'adminteste2@paynow.com.br'
email_admin_3 = 'adminteste3@paynow.com.br'

Admin.create(email: email_admin_1, permitted: 0)
Admin.create(email: email_admin_2, permitted: 0)
Admin.create(email: email_admin_3, permitted: 1)

comp_1 = 'Codeplay SA'
user_comp_1 = 'user@codeplay.com'
admin_comp_1 = 'admin@codeplay.com'
comp_2 = 'Empresa1 SA'
user_comp_2 = 'user@empresa1.com'
admin_comp_2 = 'admin@empresa1.com'

company_1 = Company.create(corporate_name: comp_1, cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                            city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                            address_complement: '', billing_email: 'faturamento@codeplay.com')

User.create(email:user_comp_1, password: '123456', role: 0, company: company_1)
User.create(email:admin_comp_1, password: '123456', role: 1, company: company_1)
DomainRecord.create(email_client_admin: admin_comp_1, domain: 'codeplay.com', company: company_1)
DomainRecord.create(email: user_comp_1, domain: 'codeplay.com', company: company_1)

company_2 = Company.create(corporate_name: comp_2, cnpj: '44.212.343/0001-42' , state: 'São Paulo', 
                            city: 'Campinas', district: 'Csmpos', street: 'rua 2', number: '13', 
                            address_complement: '', billing_email: 'faturamento@empresa1.com')
User.create(email: user_comp_2 , password: '123456', role: 0, company: company_2)
User.create(email: admin_comp_2, password: '123456', role: 1, company: company_2)
DomainRecord.create(email_client_admin: admin_comp_2, domain: 'empresa1.com', company: company_2)
DomainRecord.create(email: user_comp_2, domain: 'empresa1.com', company: company_2)

PaymentOption.create(name: 'Boleto', fee: 1.9, max_money_fee: 20)
PaymentOption.create(name: 'PIX', fee: 1.3, max_money_fee: 21)
PaymentOption.create(name: 'Cartão de Crédito MasterChef', fee: 1.2, max_money_fee: 24)

BankCode.create(code: '001', bank:'Banco do Brasil S.A.')
BankCode.create(code: '029', bank:'Banco Itaú Consignado S.A.')

company_1 = Company.where(corporate_name: comp_1).first
company_2 = Company.where(corporate_name: comp_2).first
pay_1 = PaymentOption.where(name: 'Boleto').first
pay_2 = PaymentOption.where(name: 'Cartão de Crédito MasterChef').first
pay_3 = PaymentOption.where(name: 'PIX').first
bank1 = BankCode.where(code: '001').first
bank2 = BankCode.where(code: '029').first

boleto1 = BoletoRegisterOption.new(company: company_1, payment_option: pay_1, bank_code: bank1, agency_number: '2050', account_number: '123.555-8')
if boleto1.save
  byebug
  PaymentCompany.create(company: company_1, payment_option: pay_1)
end
creditcard1 = CreditCardRegisterOption.new(company: company_1, payment_option: pay_2, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
if creditcard1.save
  byebug
  PaymentCompany.create(company: company_1, payment_option: pay_2)
end
pix1 = PixRegisterOption.new(company: company_1, payment_option: pay_3, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank2)
if pix1.save
  byebug
  PaymentCompany.create(company: company_1, payment_option: pay_3)
end


boleto2 = BoletoRegisterOption.new(company: company_2, payment_option: pay_1, bank_code: bank2, agency_number: '2050', account_number: '123.222-8')
if boleto2.save
  byebug
  PaymentCompany.create(company: company_2, payment_option: pay_1)
end
pix2 = PixRegisterOption.new(company: company_2, payment_option: pay_3, pix_key: 'APLB86HpLBtcF296rTuN', bank_code: bank2)
if pix2.save
  byebug
  PaymentCompany.create(company: company_2, payment_option: pay_3)
end



# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
