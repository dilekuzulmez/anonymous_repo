class CreateAdvertisements < ActiveRecord::Migration[5.1]
  def change
    create_table :advertisements do |t|
      t.integer :promotion_id
      t.string :title
      t.daterange :duration
      t.text :description
      t.boolean :active

      t.timestamps
    end
  end
end
