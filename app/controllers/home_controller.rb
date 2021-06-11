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
  
  private

  def check_current_user
    if current_user
      domain = current_user.email.split('@').last
      if domain == "paynow.com.br" && !Admin.where(email: current_user.email).empty?        
        current_user.admin!
        puts 'ADMIN'
      elsif DomainRecord.where(domain: domain).empty?
        current_user.client_admin_sign_up!
        DomainRecord.create!(email_client_admin: current_user.email, domain: domain)
        puts 'NEW C ADMIN'
      elsif !DomainRecord.where(domain: domain).empty? && DomainRecord.where(domain: domain).first.company.blank?
        current_user.client_admin_sign_up!
        puts 'return new C ADMIN'
      elsif !DomainRecord.where(email_client_admin: current_user.email).empty?
        current_user.client_admin!
        puts 'C ADMIN'
      elsif !DomainRecord.where(email: current_user.email).empty?
        current_user.client!
        puts 'CLIENT'
      elsif DomainRecord.where(email: current_user.email).empty?
        current_user.client!
        company = DomainRecord.where(domain: domain).first.company
        User.where(email: current_user.email).first.update(company: company)
        current_user.company = User.where(email: current_user.email).first.company
        DomainRecord.create(email: current_user.email, domain: domain, company: current_user.company) 
        puts 'NEW C'
      end
    end
  end
  def check_client_admin
    if current_user
      if current_user.client_admin? || current_user.client_admin_sign_up?
        domain = current_user.email.split('@').last
        if DomainRecord.where(email_client_admin: current_user.email).empty?
          if DomainRecord.where(domain: domain).first
            email = DomainRecord.where(domain: domain).first.email_client_admin
            DomainRecord.where(email_client_admin: email).first.update(email_client_admin: current_user.email)
          end
        end
      end
    end
  end
end