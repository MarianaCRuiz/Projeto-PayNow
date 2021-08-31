class AddIndexToDomainRecord < ActiveRecord::Migration[6.1]
  def change
    add_index :domain_records, [:email, :domain], unique: true
    add_index :domain_records, [:email_client_admin, :domain], unique: true
  end
end
