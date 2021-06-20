class AddCodeToCharge < ActiveRecord::Migration[6.1]
  def change
    add_column :charges, :status_returned_code, :string
  end
end
