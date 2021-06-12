class AddTypeToPaymentOption < ActiveRecord::Migration[6.1]
  def change
    add_column :payment_options, :payment_type, :integer, null: false, default: 0
  end
end
