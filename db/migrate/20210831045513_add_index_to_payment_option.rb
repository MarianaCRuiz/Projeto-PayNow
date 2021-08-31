class AddIndexToPaymentOption < ActiveRecord::Migration[6.1]
  def change
    add_index :payment_options, :name, unique: true
  end
end
