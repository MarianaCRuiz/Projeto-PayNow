class BlockCompany < ApplicationRecord
  belongs_to :company
  validates :email_2, presence: true, if: :checking_email
  def checking_email
    if email_1 && email_2 == email_1
      errors.add :base, 'são necessários dois administradores diferentes para bloquear uma empresa'
    end
  end
end
