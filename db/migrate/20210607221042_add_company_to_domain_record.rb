class AddCompanyToDomainRecord < ActiveRecord::Migration[6.1]
  def change
    add_reference :domain_records, :company, null: true, foreign_key: true
  end
end
