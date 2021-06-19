class AddColumnsToHistoricProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :historic_products, :boleto_discount, :string
    add_column :historic_products, :credit_card_discount, :string
    add_column :historic_products, :pix_discount, :string
  end
end
