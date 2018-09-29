class AddPaymentTypeAndSellChannelToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :payment_type, :string
    add_column :orders, :sale_channel, :string
  end
end
