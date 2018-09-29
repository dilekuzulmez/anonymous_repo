class ChangeMatchConstraints < ActiveRecord::Migration[5.1]
  def change
    change_column_null :matches, :stadium_id, true
    change_column_null :matches, :home_team_id, true
    change_column_null :matches, :away_team_id, true

    add_column :matches, :name, :string
  end
end
