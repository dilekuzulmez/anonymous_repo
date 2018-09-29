class AddIsActiveToSeason < ActiveRecord::Migration[5.1]
  def change
    add_column :seasons, :is_active, :boolean, default: false
  end
end
