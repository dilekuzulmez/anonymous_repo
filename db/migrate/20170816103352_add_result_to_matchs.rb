class AddResultToMatchs < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :home_team_score, :integer, :default => 0
    add_column :matches, :away_team_score, :integer, :default => 0
  end
end
