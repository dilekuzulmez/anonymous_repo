class AddColumnsQuantityToPromotion < ActiveRecord::Migration[5.1]
  def change
    add_column :promotions, :quantity, :integer
  end
end
