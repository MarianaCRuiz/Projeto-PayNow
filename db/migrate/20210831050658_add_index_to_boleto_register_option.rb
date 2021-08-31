class AddIndexToBoletoRegisterOption < ActiveRecord::Migration[6.1]
  def change
    add_index :boleto_register_options, [:account_number, :bank_code_id, :agency_number], unique: true, name: 'boleto_account'
  end
end
