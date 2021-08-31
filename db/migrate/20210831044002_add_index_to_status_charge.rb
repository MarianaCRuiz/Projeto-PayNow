class AddIndexToStatusCharge < ActiveRecord::Migration[6.1]
  def change
    add_index :status_charges, :code, unique: true
    add_index :status_charges, :description, unique: true
  end
end
