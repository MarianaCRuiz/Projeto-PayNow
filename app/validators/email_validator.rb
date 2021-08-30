require 'mail'
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, value)
    m = Mail::Address.new(value)
    r = m.domain.present? && m.domain.match('\.') && m.address == value
    domain = 'gmail.com yahoo.com hotmail.com msn.com yahoo.com.br outlook.com uol.com.br terra.com.br'
    domain = domain.split
    r = false if domain.any?(m.domain) == true
    r = false if m.domain == 'paynow.com.br' && Admin.where(email: m.address).empty?
    record.errors.add(:attribute, 'email inválido') unless r
  end
end
