class AddSeasonTicketTeamIdsToSeason < ActiveRecord::Migration[5.1]
  def change
    add_column :seasons, :season_ticket_team_ids, :integer, array: true, default: []
  end
end
