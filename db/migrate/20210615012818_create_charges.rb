class CreateCharges < ActiveRecord::Migration[6.1]
  def change
    create_table :charges do |t|
      t.string :token
      t.string :client_name
      t.string :client_cpf
      t.string :product_token
      t.string :company_token
      t.string :payment_method
      t.string :client_address
      t.string :card_number
      t.string :card_name
      t.string :cvv_code
      t.decimal :price
      t.decimal :discount
      t.string :product_name
      t.decimal :charge_price
      t.date :due_deadline
      t.date :payment_date
      t.date :attempt_date
      t.references :company, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :final_client, null: false, foreign_key: true
      t.references :boleto_register_option, null: true, foreign_key: true
      t.references :credit_card_register_option, true: false, foreign_key: true
      t.references :pix_register_option, null: true, foreign_key: true
      t.references :status_charge, null: false, foreign_key: true
      t.references :payment_option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
