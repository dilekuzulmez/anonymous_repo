class CreatePromotions < ActiveRecord::Migration[5.1]
  def change
    create_table :promotions do |t|
      t.string :code, limit: 32, null: false
      t.index :code, unique: true
      t.string :slug
      t.index :slug, unique: true
      t.string :discount_type, limit: 32, null: false
      t.decimal :discount_amount, null: false, default: 0.0, precision: 10, scale: 2
      t.boolean :active, default: false
      t.string :description
      t.timestamps
    end
  end
end
