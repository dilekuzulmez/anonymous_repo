class AddOrderCodeColumnToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :order_code, :string
  end
end
