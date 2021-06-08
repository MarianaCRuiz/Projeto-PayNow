class User < ApplicationRecord
  belongs_to :company, optional: true
  
  validates :email, :presence => true, :email => true
  
  enum role: {client: 0, client_admin: 1, admin: 2, client_admin_sign_up: 3}
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  
end
