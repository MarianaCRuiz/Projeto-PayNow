class CreateAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table :admins do |t|
      t.string :email
      t.integer :permitted, null: false, default: 0

      t.timestamps
    end
  end
end
