class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :corporate_name
      t.string :cnpj
      t.string :state
      t.string :city
      t.string :district
      t.string :street
      t.string :number
      t.string :address_complement, null: true
      t.string :billing_email
      t.string :token

      t.timestamps
    end
  end
end
