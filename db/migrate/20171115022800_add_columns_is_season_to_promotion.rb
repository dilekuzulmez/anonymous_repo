class AddColumnsIsSeasonToPromotion < ActiveRecord::Migration[5.1]
  def change
    add_column :promotions, :is_season, :boolean, default: false
  end
end
