class CreateBlockCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :block_companies do |t|
      t.references :company, null: false, foreign_key: true
      t.string :email1
      t.string :email2
      t.boolean :vote1, null: false, default: true
      t.boolean :vote2, null: false, default: true

      t.timestamps
    end
  end
end
