class CreateCustomersPromotions < ActiveRecord::Migration[5.1]
  def change
    create_table :customers_promotions do |t|
      t.references :customer, foreign_key: true
      t.references :promotion, foreign_key: true

      t.timestamps
    end
  end
end
