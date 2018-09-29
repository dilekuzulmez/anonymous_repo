class AddIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :stadiums, :name
    add_index :teams, :name
    add_index :notifications, :viewed_at, where: "viewed_at IS NULL"
  end
end
