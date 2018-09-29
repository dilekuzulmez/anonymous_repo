class AddColumnsLimitNumberUsedToPromotion < ActiveRecord::Migration[5.1]
  def change
    add_column :promotions, :limit_number_used, :integer
  end
end
