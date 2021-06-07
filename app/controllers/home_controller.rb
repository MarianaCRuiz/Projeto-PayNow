class HomeController < ApplicationController
  before_action :check_current_user
  def index
  end
  
  private

  def check_current_user
    if current_user
      domain = current_user.email.split('@').last
      if domain == "paynow.com.br" && User.where(email: current_user.email) != []
        current_user.admin!
      elsif DomainRecord.where(domain: domain) == []
        current_user.client_admin_first_login!
        DomainRecord.create(email_client_admin: current_user.email, domain: domain)
      elsif DomainRecord.where(email_client_admin: current_user.email) != []
        current_user.client_admin!
      elsif DomainRecord.where(email: current_user.email) != []
        current_user.client!
      elsif DomainRecord.where(email: current_user.email) == []
        current_user.client!
        DomainRecord.create(email: current_user.email, domain: domain)      
      end
    end
  end

end