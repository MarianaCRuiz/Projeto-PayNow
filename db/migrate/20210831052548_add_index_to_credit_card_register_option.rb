class AddIndexToCreditCardRegisterOption < ActiveRecord::Migration[6.1]
  def change
    add_index :credit_card_register_options, [:credit_card_operator_token, :company_id], unique: true, name: 'cc_token'
  end
end
