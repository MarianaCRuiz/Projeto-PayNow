class AddColumnToCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :status, :integer, null: false, default: 0
  end
end
