class AddTournamentToSeason < ActiveRecord::Migration[5.1]
  def change
    add_column :seasons, :tournament, :integer
  end
end
