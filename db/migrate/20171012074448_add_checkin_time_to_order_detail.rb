class AddCheckinTimeToOrderDetail < ActiveRecord::Migration[5.1]
  def change
    add_column :order_details, :check_in_time, :datetime
  end
end
