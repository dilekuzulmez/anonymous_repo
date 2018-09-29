class CreateZones < ActiveRecord::Migration[5.1]
  def change
    create_table :zones do |t|
      t.string :code, null: false
      t.string :description
      t.integer :capacity, null: false, default: 0
      t.money :price, null: false, default: 0.0
      t.string :slug
      t.index :slug, unique: true
      t.belongs_to :stadium, index: true, foreign_key: { to_table: :stadiums }
      t.timestamps
    end

    add_index :zones, [:code, :stadium_id], unique: true
  end
end
