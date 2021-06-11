class User < ApplicationRecord
  belongs_to :company, optional: true

  validates :email, presence: true, email: true
  validates :email, uniqueness: true
  
  enum role: {client: 0, client_admin: 1, admin: 2, client_admin_sign_up: 3}
                  # Include default devise modules. Others available are:
                  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable  

end
