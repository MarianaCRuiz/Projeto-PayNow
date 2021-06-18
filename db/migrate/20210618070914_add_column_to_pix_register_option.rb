class AddColumnToPixRegisterOption < ActiveRecord::Migration[6.1]
  def change
    add_column :pix_register_options, :status, :integer, null: false, default: 0
  end
end
