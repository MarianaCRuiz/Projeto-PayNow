class CreateBoletoRegisterOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :boleto_register_options do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name
      t.string :token
      t.string :bank_code
      t.string :agency_number
      t.string :account_number

      t.timestamps
    end
  end
end
