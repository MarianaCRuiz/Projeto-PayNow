class HomeController < ApplicationController
  before_action :check_client_admin
  before_action :check_current_user

  def index
    if user_signed_in?
      @domainrecord_1 = DomainRecord.find_by(email: current_user.email)
      @domainrecord_2 = DomainRecord.find_by(email_client_admin: current_user.email)
      @company = current_user.company if current_user.client? || current_user.client_admin?
    end
  end

  private

  def check_current_user
    if current_user
      domain = current_user.email.split('@').last
      client_admin = DomainRecord.find_by(email_client_admin: current_user.email)
      client = DomainRecord.find_by(email: current_user.email)
      if client_admin && client_admin.blocked? then current_user.blocked!
      elsif client_admin && client_admin.company then current_user.client_admin!
      elsif client && client.blocked? then current_user.blocked!
      end
    end
  end

  def check_client_admin
    if current_user && (current_user.client_admin? || current_user.client_admin_sign_up?)
      domain = current_user.email.split('@').last
      if DomainRecord.find_by(email_client_admin: current_user.email).blank? && DomainRecord.find_by(domain: domain)
        email = DomainRecord.where(domain: domain).first.email_client_admin
        DomainRecord.find_by(email_client_admin: email).update(email_client_admin: current_user.email)
      end
    end
  end
end
