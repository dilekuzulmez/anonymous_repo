class CreateGates < ActiveRecord::Migration[5.1]
  def change
    create_table :gates do |t|
      t.string :code, null: false
      t.string :slug
      t.index :slug, unique: true
      t.belongs_to :stadium, index: true, foreign_key: { to_table: :stadiums }, null: false
      t.timestamps
    end

    add_index :gates, [:code, :stadium_id], unique: true
  end
end
