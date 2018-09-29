class AddLeagueIdToSeasons < ActiveRecord::Migration[5.1]
  def change
    remove_column :seasons, :tournament
    add_column :seasons, :league_id, :integer
  end
end
