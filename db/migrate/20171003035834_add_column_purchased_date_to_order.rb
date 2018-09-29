class AddColumnPurchasedDateToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :purchased_date, :datetime
  end
end
