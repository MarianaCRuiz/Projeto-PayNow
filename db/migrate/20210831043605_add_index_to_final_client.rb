class AddIndexToFinalClient < ActiveRecord::Migration[6.1]
  def change
    add_index :final_clients, :token, unique: true
    add_index :final_clients, :cpf, unique: true
  end
end
