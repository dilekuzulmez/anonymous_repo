class AddAmountMatchesToSeasons < ActiveRecord::Migration[5.1]
  def change
    add_column :seasons, :amount_matches, :integer
  end
end
