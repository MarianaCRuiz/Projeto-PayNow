class AddIndexToBankCode < ActiveRecord::Migration[6.1]
  def change
    add_index :bank_codes, :bank, unique: true
    add_index :bank_codes, :code, unique: true
  end
end
