class AddIndexToProduct < ActiveRecord::Migration[6.1]
  def change
    add_index :products, [:name, :company_id], unique: true
    add_index :products, [:token, :company_id], unique: true
  end
end
