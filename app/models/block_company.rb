class BlockCompany < ApplicationRecord
  belongs_to :company
  validates :email2, presence: true, if: :checking_email
  def checking_email
    if email1 && email2 == email1
      errors.add :base, 'são necessários dois administradores diferentes para bloquear uma empresa'
    end
  end
end
