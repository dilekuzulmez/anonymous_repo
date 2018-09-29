class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.references :imageable, polymorphic: true
      t.attachment :image

      t.timestamps
    end
  end
end
