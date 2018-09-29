class CreateTicketTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :ticket_types do |t|
      t.belongs_to :match, index: true, foreign_key: true, null: false
      t.belongs_to :zone, index: true, foreign_key: true
      t.integer :quantity, null: false
      t.string :code, null: false
      t.string :slug
      t.index :slug, unique: true
      t.string :description
      t.money :price, null: false
      t.index [:match_id, :code], unique: true
      t.timestamps
    end
  end
end
