class CreateStadiums < ActiveRecord::Migration[5.1]
  def change
    create_table :stadiums do |t|
      t.string :name, null: false
      t.string :address
      t.string :contact
      t.string :slug
      t.index :slug, unique: true
      t.references :team, index: true
      t.timestamps
    end
  end
end
