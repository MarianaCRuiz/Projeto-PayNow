class CompanyClient < ApplicationRecord
  belongs_to :final_client
  belongs_to :company
end
