class AddBankCodeToBoletoRegisterOption < ActiveRecord::Migration[6.1]
  def change
    add_reference :boleto_register_options, :bank_code, null: false, foreign_key: true
  end
end
