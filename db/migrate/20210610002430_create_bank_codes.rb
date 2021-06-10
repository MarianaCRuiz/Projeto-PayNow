class CreateBankCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :bank_codes do |t|
      t.string :code
      t.string :bank

      t.timestamps
    end
  end
end
