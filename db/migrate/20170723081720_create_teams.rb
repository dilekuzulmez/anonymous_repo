class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :description
      t.string :slug, unique: true
      t.timestamps

      t.index :slug, unique: true
    end
  end
end
