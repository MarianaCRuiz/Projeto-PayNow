class CreateReceiptFilters < ActiveRecord::Migration[6.1]
  def change
    create_table :receipt_filters do |t|
      t.string :token

      t.timestamps
    end
  end
end
