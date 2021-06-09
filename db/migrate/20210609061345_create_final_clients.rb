class CreateFinalClients < ActiveRecord::Migration[6.1]
  def change
    create_table :final_clients do |t|
      t.string :name
      t.string :cpf
      t.string :token

      t.timestamps
    end
  end
end
