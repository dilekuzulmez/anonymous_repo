class CreateMatchsPromotions < ActiveRecord::Migration[5.1]
  def change
    create_table :matchs_promotions do |t|
      t.references :match, foreign_key: true
      t.references :promotion, foreign_key: true

      t.timestamps
    end
  end
end
