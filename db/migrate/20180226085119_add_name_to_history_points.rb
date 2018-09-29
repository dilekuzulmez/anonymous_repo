class AddNameToHistoryPoints < ActiveRecord::Migration[5.1]
  def change
    add_column :history_points, :name, :string
  end
end
