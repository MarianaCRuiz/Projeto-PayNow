class AddIndexToPixRegisterOption < ActiveRecord::Migration[6.1]
  def change
    add_index :pix_register_options, [:pix_key, :company_id], unique: true, name: 'pix_key_index'
  end
end
