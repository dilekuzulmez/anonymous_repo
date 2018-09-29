class CreateHistoryPoints < ActiveRecord::Migration[5.1]
  def change
    create_table :history_points do |t|
      t.references :customer, foreign_key: true
      t.references :loyalty_point_rule, foreign_key: true
      t.integer :point

      t.timestamps
    end
  end
end
