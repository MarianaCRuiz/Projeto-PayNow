class CreateDomainRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :domain_records do |t|
      t.string :email, null: true
      t.string :email_client_admin, null: true
      t.string :domain
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
