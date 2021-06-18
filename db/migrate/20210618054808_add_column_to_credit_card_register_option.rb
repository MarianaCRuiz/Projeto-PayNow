class AddColumnToCreditCardRegisterOption < ActiveRecord::Migration[6.1]
  def change
    add_column :credit_card_register_options, :status, :integer, null: false, default: 0
  end
end
