class CreatePixRegisterOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :pix_register_options do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name
      t.string :pix_key
      t.string :bank_code

      t.timestamps
    end
  end
end
