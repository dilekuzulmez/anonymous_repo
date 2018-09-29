class AddLeagueIdToBundleAdditionals < ActiveRecord::Migration[5.1]
  def change
    add_column :bundle_additionals, :league_id, :integer
  end
end
