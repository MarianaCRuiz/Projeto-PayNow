class HomeController < ApplicationController
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
        DomainRecord.create(email_client_admin: current_user.email, domain: domain)
        puts 'NEW C ADMIN'
      elsif !DomainRecord.where(email_client_admin: current_user.email).empty?
        current_user.client_admin!
        puts 'C ADMIN'
      elsif !DomainRecord.where(email: current_user.email).empty?
        current_user.client!
        if current_user.company == ''
          company = DomainRecord.where(domain: domain).first.company_id
          current_user.company = Company.find(company)
        end
        puts 'CLIENT'
      elsif DomainRecord.where(email: current_user.email).empty?
        current_user.client!
        company = DomainRecord.where(domain: domain).first.company_id
        current_user.company = Company.find(company)
        DomainRecord.create(email: current_user.email, domain: domain, company_id: company)     
        puts 'NEW C'
      end
    end
  end

end