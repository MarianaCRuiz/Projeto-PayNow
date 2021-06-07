class DomainRecord < ApplicationRecord
  enum status: {allowed: 0, blocked: 1}
end
