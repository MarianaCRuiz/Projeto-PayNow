class CreateStatusCharges < ActiveRecord::Migration[6.1]
  def change
    create_table :status_charges do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
