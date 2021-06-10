class BoletoRegisterOption < ApplicationRecord
  belongs_to :company
  belongs_to :bank_code
end
