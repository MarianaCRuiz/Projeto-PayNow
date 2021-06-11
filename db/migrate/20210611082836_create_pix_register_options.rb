class CreatePixRegisterOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :pix_register_options do |t|
      t.references :company, null: false, foreign_key: true
      t.string :pix_key
      t.references :bank_code, null: false, foreign_key: true
      t.references :payment_option, null: false, foreign_key: true
      t.string :name
      t.decimal :fee
      t.decimal :max_money_fee

      t.timestamps
    end
  end
end
