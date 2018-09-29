class CreateConversionRates < ActiveRecord::Migration[5.1]
  def change
    create_table :conversion_rates do |t|
      t.integer :code
      t.text :description
      t.integer :money
      t.integer :point
      t.boolean :active

      t.timestamps
    end
  end
end
