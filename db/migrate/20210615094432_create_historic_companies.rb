class CreateHistoricCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :historic_companies do |t|
      t.references :company, null: false, foreign_key: true
      t.string :token
      t.string :corporate_name
      t.string :cnpj
      t.string :state
      t.string :city
      t.string :district
      t.string :street
      t.string :number
      t.string :address_complement
      t.string :billing_email

      t.timestamps
    end
  end
end
