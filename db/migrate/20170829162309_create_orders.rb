class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.belongs_to :match, index: true, foreign_key: true, null: false
      t.string :kind, limit: 32
      t.belongs_to :customer, index: true
      t.string :shipping_address
      t.bigint :created_by_id
      t.string :created_by_type
      t.boolean :paid, default: false
      t.string :promotion_code, limit: 32
      t.money :discount_amount, default: 0.0
      t.string :discount_type, limit: 128
      t.timestamp :expired_at
      t.timestamps
    end

    add_index :orders, [:created_by_id, :created_by_type]
  end
end
