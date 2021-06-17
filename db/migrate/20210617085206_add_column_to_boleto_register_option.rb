class AddColumnToBoletoRegisterOption < ActiveRecord::Migration[6.1]
  def change
    add_column :boleto_register_options, :status, :integer, null: false, default: 0
  end
end
