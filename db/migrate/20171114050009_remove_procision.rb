class RemoveProcision < ActiveRecord::Migration[5.1]
  def up
    change_column :zones, :price, :decimal, :null => false, :default => 0.0
    change_column :ticket_types, :price, :decimal, :null => false, :default => 0.0
    change_column :orders, :discount_amount, :decimal, :null => false, :default => 0.0
    change_column :order_details, :unit_price, :decimal, :null => false, :default => 0.0
    change_column :transaction_histories, :amount, :decimal, :null => false, :default => 0.0
  end

  def down
    change_column :zones, :price, :money, :null => false, :default => 0.0
    change_column :ticket_types, :price, :money, :null => false, :default => 0.0
    change_column :orders, :discount_amount, :money, :null => false, :default => 0.0
    change_column :order_details, :unit_price, :money, :null => false, :default => 0.0
    change_column :transaction_histories, :amount, :money, :null => false, :default => 0.0
  end
end
