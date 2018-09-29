class CreateLoyaltyPointRules < ActiveRecord::Migration[5.1]
  def change
    create_table :loyalty_point_rules do |t|
      t.string :name
      t.string :description
      t.integer :point

      t.timestamps
    end
  end
end
