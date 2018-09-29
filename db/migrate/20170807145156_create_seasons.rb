class CreateSeasons < ActiveRecord::Migration[5.1]
  def change
    create_table :seasons do |t|
      t.string :name
      t.daterange :duration, null: false
      t.timestamps
    end

    change_table :matches do |t|
      t.references :season, index: true, foreign_key: true
    end

    create_table :seasons_teams, id: false do |t|
      t.belongs_to :season, index: true
      t.belongs_to :team, index: true
    end
  end
end
