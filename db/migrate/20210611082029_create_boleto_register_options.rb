class CreateBoletoRegisterOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :boleto_register_options do |t|
      t.references :company, null: false, foreign_key: true
      t.string :token
      t.string :agency_number
      t.string :account_number
      t.references :payment_option, null: false, foreign_key: true
      t.string :name
      t.decimal :fee
      t.decimal :max_money_fee
      t.references :bank_code, null: false, foreign_key: true

      t.timestamps
    end
  end
end
