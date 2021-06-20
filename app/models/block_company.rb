class BlockCompany < ApplicationRecord
  belongs_to :company
  validates :email_2, presence: true, if: :checking_email
  def checking_email
    if self.email_1 && self.email_2 == self.email_1
      self.errors.add :base, "são necessários dois administradores diferentes para bloquear uma empresa"
    end
  end
end
