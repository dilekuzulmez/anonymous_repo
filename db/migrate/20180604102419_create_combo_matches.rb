class CreateComboMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :combos_matches do |t|
      t.references :match, foreign_key: true
      t.references :combo, foreign_key: true

      t.timestamps
    end
  end
end
