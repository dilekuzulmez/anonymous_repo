class AddColumnsNumberUsedToCustomersPromotion < ActiveRecord::Migration[5.1]
  def change
    add_column :customers_promotions, :number_used, :integer, default: 0
  end
end
