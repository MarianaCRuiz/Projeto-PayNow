class CreatePaymentCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_companies do |t|
      t.references :payment_option, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
