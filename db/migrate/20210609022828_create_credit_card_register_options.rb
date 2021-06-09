class CreateCreditCardRegisterOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :credit_card_register_options do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name
      t.string :credit_card_operator_token

      t.timestamps
    end
  end
end
