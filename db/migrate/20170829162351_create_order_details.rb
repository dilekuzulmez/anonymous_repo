class CreateOrderDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :order_details do |t|
      t.belongs_to :order, index: true, foreign_key: true
      t.belongs_to :ticket_type, index: true, foreign_key: true
      t.integer :quantity, null: false
      t.money :unit_price, null: false
      t.timestamps
    end
  end
end
