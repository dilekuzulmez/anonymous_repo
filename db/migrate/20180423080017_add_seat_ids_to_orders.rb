class AddSeatIdsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :seat_ids, :text, array: true, default: []
  end
end
