class CreateCombos < ActiveRecord::Migration[5.1]
  def change
    create_table :combos do |t|
      t.string :code
      t.string :ticket_type
      t.text :description
      t.decimal :price
      t.boolean :is_active

      t.timestamps
    end
  end
end
