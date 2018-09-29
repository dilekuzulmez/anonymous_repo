class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.belongs_to :stadium, index: true, foreign_key: { to_table: :stadiums }, null: false
      t.bigint :home_team_id, null: false
      t.bigint :away_team_id, null: false
      t.string :round
      t.timestamp :start_time, null: false
      t.timestamps
    end

    add_index :matches, :home_team_id
    add_index :matches, :away_team_id
    add_index :matches, :start_time
    add_foreign_key :matches, :teams, column: :home_team_id, on_delete: :nullify
    add_foreign_key :matches, :teams, column: :away_team_id, on_delete: :nullify
  end
end
