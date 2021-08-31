class AddIndexToCompanyClient < ActiveRecord::Migration[6.1]
  def change
    add_index :company_clients, [:final_client_id, :company_id], unique: true
  end
end
