class HomeController < ApplicationController
  before_action :check_client_admin
  before_action :check_current_user
  
  def index
    if user_signed_in?
      if current_user.client? || current_user.client_admin?
        @company = current_user.company
      end
    end
  end

  def receipts
    @receipts = Receipt.all
  end
  
  private

  def check_current_user
    if current_user && current_user
      domain = current_user.email.split('@').last
      if domain == "paynow.com.br" && !Admin.where(email: current_user.email).empty?        
        current_user.admin! 
              # puts 'ADMIN'
      elsif DomainRecord.where(domain: domain).empty?
        current_user.client_admin_sign_up!
        DomainRecord.create!(email_client_admin: current_user.email, domain: domain) 
              # puts 'NEW C ADMIN'
      elsif !DomainRecord.where(domain: domain).empty? && DomainRecord.where(domain: domain).first.company.blank?
        current_user.client_admin_sign_up! 
              #  puts 'return new C ADMIN'
      elsif !DomainRecord.find_by(email_client_admin: current_user.email).blank?
        current_user.client_admin! 
              #  puts 'C ADMIN'
      elsif DomainRecord.find_by(email: current_user.email) && DomainRecord.find_by(email: current_user.email).blocked?
        current_user.blocked!
        puts 'blocked'
      elsif !DomainRecord.find_by(email: current_user.email).blank?
        current_user.client! 
              #  puts 'CLIENT'
      elsif DomainRecord.find_by(email: current_user.email).blank?
        current_user.client!
        company = DomainRecord.where(domain: domain).first.company
        User.find_by(email: current_user.email).update(company: company)
        current_user.company = User.find_by(email: current_user.email).company
        DomainRecord.create(email: current_user.email, domain: domain, company: current_user.company)  
              # puts 'NEW C'
      end
    end
  end
  def check_client_admin
    if current_user
      if current_user.client_admin? || current_user.client_admin_sign_up?
        domain = current_user.email.split('@').last
        if DomainRecord.find_by(email_client_admin: current_user.email).blank?
          if DomainRecord.find_by(domain: domain)
            email = DomainRecord.where(domain: domain).first.email_client_admin
            DomainRecord.find_by(email_client_admin: email).update(email_client_admin: current_user.email)
          end
        end
      end
    end
  end
end