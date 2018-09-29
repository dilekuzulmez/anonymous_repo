class AddFavoriteTeamToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :favorite_team_id, :integer
    add_index :customers, :favorite_team_id
  end
end
