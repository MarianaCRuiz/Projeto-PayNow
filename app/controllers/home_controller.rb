class HomeController < ApplicationController
  before_action :check_client_admin
  before_action :check_current_user

  def index
    return unless user_signed_in?

    @domainrecord1 = DomainRecord.find_by(email: current_user.email)
    @domainrecord2 = DomainRecord.find_by(email_client_admin: current_user.email)
    @company = current_user.company if current_user.client? || current_user.client_admin?
  end

  private

  def check_current_user
    return unless current_user

    client_admin = DomainRecord.find_by(email_client_admin: current_user.email)
    client = DomainRecord.find_by(email: current_user.email)
    if client_admin&.blocked? || client&.blocked? then current_user.blocked!
    elsif client_admin&.company then current_user.client_admin! end
  end

  def check_client_admin
    return unless current_user && (current_user.client_admin? || current_user.client_admin_sign_up?)

    @domain = current_user.email.split('@').last
    unless DomainRecord.find_by(email_client_admin: current_user.email).blank? && DomainRecord.find_by(domain: @domain)
      return; end

    find_email
  end

  def find_email
    @email = DomainRecord.where(domain: @domain).first.email_client_admin
    DomainRecord.find_by(email_client_admin: @email).update(email_client_admin: current_user.email)
  end
end
