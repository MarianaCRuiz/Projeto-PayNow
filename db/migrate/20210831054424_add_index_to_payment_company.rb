class AddIndexToPaymentCompany < ActiveRecord::Migration[6.1]
  def change
    add_index :payment_companies, [:payment_option_id, :company_id], unique: true
  end
end
