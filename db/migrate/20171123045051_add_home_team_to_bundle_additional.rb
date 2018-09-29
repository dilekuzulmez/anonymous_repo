class AddHomeTeamToBundleAdditional < ActiveRecord::Migration[5.1]
  def change
    add_column :bundle_additionals, :home_team_id, :integer
  end
end
