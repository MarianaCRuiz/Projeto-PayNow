class AddColumnToCharge < ActiveRecord::Migration[6.1]
  def change
    add_column :charges, :status_returned, :string
  end
end
