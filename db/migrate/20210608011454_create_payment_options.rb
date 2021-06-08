class CreatePaymentOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_options do |t|
      t.string :name
      t.decimal :fee
      t.decimal :max_money_fee, null: true
      t.integer :state, default: 0, null: false

      t.timestamps
    end
  end
end
