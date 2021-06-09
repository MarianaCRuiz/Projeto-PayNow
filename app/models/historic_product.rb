class HistoricProduct < ApplicationRecord
  belongs_to :product
  belongs_to :company
end
