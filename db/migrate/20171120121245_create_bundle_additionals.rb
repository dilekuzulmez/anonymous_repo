class CreateBundleAdditionals < ActiveRecord::Migration[5.1]
  def change
    create_table :bundle_additionals do |t|
      t.string :code
      t.string :description
      t.decimal :price, :null => false, :default => 0.0
      t.boolean :is_active, :null => false, :default => false
      t.references :ticket_type, foreign_key: true

      t.timestamps
    end
  end
end
