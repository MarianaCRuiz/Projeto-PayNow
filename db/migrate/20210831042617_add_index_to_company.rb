class AddIndexToCompany < ActiveRecord::Migration[6.1]
  def change
    add_index :companies, :cnpj, unique: true
    add_index :companies, :billing_email, unique: true
    add_index :companies, :corporate_name, unique: true
  end
end
