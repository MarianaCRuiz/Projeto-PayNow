require 'csv'
csv_text = File.read("#{Rails.root}/public/bank_codes3.csv")
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  code, bank = row.to_s.split(' ', 2)
  BankCode.create(code: code, bank: bank)
end
csv_text2 = File.read("#{Rails.root}/public/charge_status_options.csv")
csv2 = CSV.parse(csv_text2, :headers => true)
csv2.each do |row|
  code, description = row.to_s.split(' ', 2)
  StatusCharge.create(code: code, description: description)
end

email_admin_1 = 'adminteste1@paynow.com.br'
email_admin_2 = 'adminteste2@paynow.com.br'
email_admin_3 = 'adminteste3@paynow.com.br'

Admin.create(email: email_admin_1)
Admin.create(email: email_admin_2)
User.create(email:email_admin_1, password: '123456', role: 2)

comp_1 = 'Codeplay SA'
admin_comp_1 = 'admin@codeplay.com'
user_comp_1 = 'user@codeplay.com'
user2_comp_1 = 'user2@codeplay.com'
user3_comp_1 = 'user3@codeplay.com'

comp_2 = 'Empresa1 SA'
admin_comp_2 = 'admin@empresa1.com'
user_comp_2 = 'user@empresa1.com'
user2_comp_2 = 'user2@empresa1.com'
user3_comp_2 = 'user3@empresa1.com'

company_1 = Company.create(corporate_name: comp_1, cnpj: '11.222.333/0001-44' , state: 'São Paulo', 
                            city: 'Campinas', district: 'Inova', street: 'rua 1', number: '12', 
                            address_complement: '', billing_email: 'faturamento@codeplay.com')
if company_1
  User.create(email:admin_comp_1, password: '123456', role: 1, company: company_1)
  User.create(email:user_comp_1, password: '123456', role: 0, company: company_1)
  User.create(email:user2_comp_1, password: '123456', role: 0, company: company_1)
  User.create(email:user3_comp_1, password: '123456', role: 0, company: company_1)
  DomainRecord.create(email_client_admin: admin_comp_1, domain: 'codeplay.com', company: company_1)
  DomainRecord.create(email: user_comp_1, domain: 'codeplay.com', company: company_1)
  DomainRecord.create(email: user2_comp_1, domain: 'codeplay.com', company: company_1)
  DomainRecord.create(email: user3_comp_1, domain: 'codeplay.com', company: company_1)
  company_1.token = "ab83MLX891c6BA891kmT"
  company_1.save
  byebug
end

company_2 = Company.create(corporate_name: comp_2, cnpj: '44.212.343/0001-42' , state: 'São Paulo', 
                            city: 'Campinas', district: 'Csmpos', street: 'rua 2', number: '13', 
                            address_complement: '', billing_email: 'faturamento@empresa1.com')
if company_2
  User.create(email: admin_comp_2, password: '123456', role: 1, company: company_2)
  User.create(email: user_comp_2 , password: '123456', role: 0, company: company_2)
  User.create(email: user2_comp_2 , password: '123456', role: 0, company: company_2)
  User.create(email: user3_comp_2 , password: '123456', role: 0, company: company_2)
  DomainRecord.create(email_client_admin: admin_comp_2, domain: 'empresa1.com', company: company_2)
  DomainRecord.create(email: user_comp_2, domain: 'empresa1.com', company: company_2)
  DomainRecord.create(email: user2_comp_2, domain: 'empresa1.com', company: company_2)
  DomainRecord.create(email: user3_comp_2, domain: 'empresa1.com', company: company_2)
  company_2.token = "V83Hbadp651bc1pBaFxp"
  company_2.save
end

company_3 = Company.create(corporate_name: 'Empresa 2 SA', cnpj: '44.212.234/0001-55' , state: 'São Paulo', 
                          city: 'Campinas', district: 'Bairro x', street: 'rua 2', number: '13', 
                          address_complement: '', billing_email: 'faturamento@empresa2.com', status: 1)
if company_3
  User.create(email: 'admin@empresa2.com', password: '123456', role: 1, company: company_3)
  User.create(email: 'user@empresa2.com' , password: '123456', role: 0, company: company_3)
  DomainRecord.create(email_client_admin: 'admin@empresa2.com', domain: 'empresa2.com', company: company_3, status: 1)
  DomainRecord.create(email: 'user@e,presa2.com', domain: 'empresa2.com', company: company_3, status: 1)
  company_3.token = "GV56mnT629LPZMlNX258"
  company_3.save
end

PaymentOption.create(name: 'Boleto', fee: 1.9, max_money_fee: 20, payment_type: 0)
PaymentOption.create(name: 'Boleto BB', fee: 1.8, max_money_fee: 21, payment_type: 0)
PaymentOption.create(name: 'Boleto X', fee: 1.7, max_money_fee: 22, payment_type: 0)
PaymentOption.create(name: 'Cartão de Crédito MasterChef', fee: 1.2, max_money_fee: 24, payment_type:1)
PaymentOption.create(name: 'Cartão de Crédito Pisa', fee: 1.2, max_money_fee: 24, payment_type:1)
PaymentOption.create(name: 'PIX', fee: 1.3, max_money_fee: 21, payment_type: 2)
PaymentOption.create(name: 'PIX_2', fee: 1.3, max_money_fee: 21, payment_type: 2)
PaymentOption.create(name: 'PIX_3', fee: 1.3, max_money_fee: 21, payment_type: 2)

company_1 = Company.find_by(corporate_name: comp_1)
company_2 = Company.find_by(corporate_name: comp_2)
pay_1 = PaymentOption.find_by(name: 'Boleto')
pay_11 = PaymentOption.find_by(name: 'Boleto BB')
pay_12 = PaymentOption.find_by(name: 'Boleto X')
pay_2 = PaymentOption.find_by(name: 'Cartão de Crédito MasterChef')
pay_21 = PaymentOption.find_by(name: 'Cartão de Crédito Pisa')
pay_3 = PaymentOption.find_by(name: 'PIX')
pay_31 = PaymentOption.find_by(name: 'PIX_2')
pay_32 = PaymentOption.find_by(name: 'PIX_3')

bank1 = BankCode.find_by(code: '001')
bank2 = BankCode.find_by(code: '029')

boleto1 = BoletoRegisterOption.new(company: company_1, payment_option: pay_1, bank_code: bank1, agency_number: '2050', account_number: '123.555-8')
if boleto1.save then PaymentCompany.create(company: company_1, payment_option: pay_1) end
creditcard1 = CreditCardRegisterOption.new(company: company_1, payment_option: pay_2, credit_card_operator_token: 'jdB8SD923Nmg8fR1GhJm')
if creditcard1.save then PaymentCompany.create(company: company_1, payment_option: pay_2) end
pix1 = PixRegisterOption.new(company: company_1, payment_option: pay_3, pix_key: 'AJ86gt4fLBtcF296rTuN', bank_code: bank2)
if pix1.save then PaymentCompany.create(company: company_1, payment_option: pay_3) end

boleto2 = BoletoRegisterOption.new(company: company_2, payment_option: pay_1, bank_code: bank2, agency_number: '2050', account_number: '123.222-8')
if boleto2.save then PaymentCompany.create(company: company_2, payment_option: pay_1) end
pix2 = PixRegisterOption.new(company: company_2, payment_option: pay_3, pix_key: 'APLB86HpLBtcF296rTuN', bank_code: bank2)
if pix2.save then PaymentCompany.create(company: company_2, payment_option: pay_3) end

product_1 = Product.new(name:'Produto 1', price: 53, boleto_discount: 1, company: company_1)
if product_1.save 
  HistoricProduct.create(product: product_1, company: company_1, price: product_1.price, 
                                                            boleto_discount: product_1.boleto_discount, 
                                                            credit_card_discount: product_1.credit_card_discount, 
                                                            pix_discount: product_1.pix_discount)
  product_1.token = "PAM17d4gf7mG8vb13zmT"
  product_1.save
end
product_2 = Product.new(name:'Produto 2', price: 34, credit_card_discount: 2, company: company_1)
if product_2.save
  HistoricProduct.create(product: product_2, company: company_1, price: product_2.price, 
                                                            boleto_discount: product_2.boleto_discount, 
                                                            credit_card_discount: product_2.credit_card_discount, 
                                                            pix_discount: product_2.pix_discount)
  product_2.token = "Lmc78sJyc65mamrTpXTA"                                                        
  product_2.save
end
product_3 = Product.new(name:'Produto 3', price: 45, pix_discount: 3, company: company_1)
if product_3.save
  HistoricProduct.create(product: product_3, company: company_1, price: product_3.price, 
                                                            boleto_discount: product_3.boleto_discount, 
                                                            credit_card_discount: product_3.credit_card_discount, 
                                                            pix_discount: product_3.pix_discount)
  product_3.token =  "gh62Mnc89J1Lmcpq2DmV"                                                    
  product_3.save
end

product_1 = Product.where(name: 'Produto 1').first
product_2 = Product.where(name: 'Produto 2').first
product_3 = Product.where(name: 'Produto 3').first
f1 = FinalClient.new(name: 'Cliente 1', cpf: '11122233344')
if f1.save 
  CompanyClient.create(company: company_1, final_client: f1) 
  f1.token = "LB12nmULbagt97a8fVb6"
  f1.save
end
f2 = FinalClient.new(name: 'Cliente 2', cpf: '55522233344')
if f2.save
  CompanyClient.create(company: company_2, final_client: f2)
  f2.token =  "MdKzh8ESEs4kspagejDi"
  f2.save
end
f3 = FinalClient.new(name: 'Cliente 3', cpf: '55522233355')
if f3.save
  CompanyClient.create(company: company_1, final_client: f3) 
  CompanyClient.create(company: company_2, final_client: f3)
  f3.token = "6pAeNK2jWuwHpXgChVBX"
  f3.save
end

final_client_1 = FinalClient.find_by(cpf: '11122233344')
final_client_2 = FinalClient.find_by(cpf: '55522233344')
status_charge = StatusCharge.find_by(code: '01')
status_2 = StatusCharge.find_by(code: '05')

c11 = Charge.create(client_token: final_client_1.token, 
                    client_name: final_client_1.name, client_cpf: final_client_1.cpf, 
                    company_token:company_1.token, product_token: product_1.token, 
                    payment_method: pay_1.name, client_address: 'algum endereço', 
                    due_deadline: '24/12/2023', company: company_1, final_client: final_client_1,
                    status_charge: status_charge, product: product_1,
                    payment_option: pay_1, price: 50, charge_price: 45 )
c11.created_at = Date.today - 15.days
c11.save!
c12 = Charge.create(client_token: final_client_1.token,
                    client_name: final_client_1.name, client_cpf: final_client_1.cpf, 
                    company_token:company_1.token, product_token: product_2.token, 
                    payment_method: pay_1.name, client_address: 'algum endereço', 
                    due_deadline: '30/12/2024', company: company_1, final_client: final_client_1,
                    status_charge: status_charge, product: product_2,
                    payment_option: pay_1, price: 60, charge_price: 54)
c12.created_at = Date.today - 95.days
c12.save!
Charge.create(client_token: final_client_2.token, 
              client_name: final_client_2.name, client_cpf: final_client_2.cpf, 
              company_token:company_1.token, product_token: product_1.token, 
              payment_method: pay_2.name, card_number: '1111 2222 3333 4444',
              card_name: 'CLIENTE XY', cvv_code: '123', 
              due_deadline: '25/04/2021', company: company_1, final_client: final_client_2,
              status_charge: status_charge, product: product_1,
              payment_option: pay_2, price: 50, charge_price: 45 )
Charge.create(client_token: final_client_2.token, 
              client_name: final_client_2.name, client_cpf: final_client_2.cpf, 
              company_token:company_1.token, product_token: product_2.token, 
              payment_method: pay_3.name, due_deadline: '17/12/2020', 
              company: company_1, final_client: final_client_2,
              status_charge: status_charge, product: product_2,
              payment_option: pay_3, price: 60, charge_price: 54)
c1 = Charge.new(client_token: final_client_2.token, 
                    client_name: final_client_2.name, client_cpf: final_client_2.cpf, 
                    company_token:company_1.token, product_token: product_3.token, 
                    payment_method: pay_3.name, due_deadline: '14/06/2021', 
                    company: company_1, final_client: final_client_2,
                    status_charge: status_2, product: product_3,
                    payment_option: pay_3, price: product_3.price, discount: (product_3.price*product_3.pix_discount/100),
                    charge_price: product_3.price-(product_3.price*product_3.pix_discount/100), payment_date: '14/06/2021')
c2 = Charge.new(client_token: final_client_2.token, 
                    client_name: final_client_2.name, client_cpf: final_client_2.cpf, 
                    company_token:company_1.token, product_token: product_3.token, 
                    payment_method: pay_2.name, due_deadline: '14/06/2021', 
                    card_number: '1111 2222 3333 4444',
                    card_name: 'CLIENTE XY', cvv_code: '123', 
                    company: company_1, final_client: final_client_2,
                    status_charge: status_2, product: product_3,
                    payment_option: pay_2, price: product_3.price, discount: (product_3.price*product_3.credit_card_discount/100),
                    charge_price: product_3.price-(product_3.price*product_3.credit_card_discount/100), payment_date: '14/06/2021')
if c1.save then Receipt.create(due_deadline: c1.due_deadline, payment_date: c1.payment_date, charge: c1) end
if c2.save then Receipt.create!(due_deadline: c2.due_deadline, payment_date: c2.payment_date, charge: c2) end




  # This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies)
